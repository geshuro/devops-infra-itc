#!/bin/bash
#
# modified srojo
# 
source /etc/profile
set -eu


###################
# Parse arguments #
###################
VPC_CIRD=$NETWORK
HELP=no
OPERATION=none
PROTOCOL=udp
PORT=1194
IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
PUBLICIP=$(curl -s ifconfig.me)
DNS=current
FIREWALL=no
CLIENT=
s3devsysops=$(aws s3 ls | grep "s3-devsysops" | cut -d " " -f 3)

if [ "-a" == "$1" -o "-r" == "$1" ]; then
CLIENT=$2
fi

ARGS=$(getopt -o hiuRa:rtp:I:P:d:f -- "$@")
eval set -- "$ARGS"
set +u  # Avoid unbound $1 at the end of the parsing
while true; do
    case "$1" in
        -h) HELP=yes; shift;;
        -i) OPERATION=install; shift;;
        -u) OPERATION=uninstall; shift;;
        -R) OPERATION=refresh; shift;;
        -a) OPERATION=adduser; CLIENT="$2"; shift; shift;;
        -r) OPERATION=rmuser; shift; shift;;
        -t) PROTOCOL=tcp; shift;;
        -p) PORT="$2"; shift; shift;;
        -I) IP="$2"; shift; shift;;
        -P) PUBLICIP="$2"; shift; shift;;
        -d) DNS="$2"; shift; shift;;
        #-f) FIREWALL=yes; shift;;
        --) shift; break;;
        *) break;;
    esac
done
set -u

if [[ $HELP == yes ]]; then
    echo "Install, configure and manage an OpenVPN server and its users"
    echo
    echo "This script automatically detects whether the OS is Debian-based"
    echo "or RedHat-based and acts accordingly."
    echo
    echo "Please note this script must be run as root."
    echo
    echo "You must specify one of -i, -u, -R, -a or -r argument. For all the"
    echo "other arguments, it is advised you leave them at their default"
    echo "values, unless you really know what you are doing."
    echo
    echo "The available arguments are:"
    echo "  -h       Print this help message"
    echo "  -i       Install and configure an OpenVPN server"
    echo "  -u       Uninstall OpenVPN"
    echo "  -R       Refresh OpenVPN (re-install the OS packages, but leave"
    echo "           the existing OpenVPN data untouched"
    echo "  -a USER  Add a user"
    echo "  -r       Remove a user"
    echo
    echo "The following arguments are only available in conjuction with -i:"
    echo "  -t         Use TCP instead of UDP"
    echo "  -p PORT    Port number to use (default: $PORT)"
    echo "  -I IP      Local IP address to bind to (default: $IP)"
    echo "  -P IP      Public IP address (i.e. NAT address, if applicable)"
    echo "             (default: $PUBLICIP)"
    echo "  -d CHOICE  DNS servers to use (default: $DNS)"
    echo "             allowed choices: current (use the current system"
    echo "             resolvers), cloudflare, google, opendns, verisign"
    echo "  -f         Configure the firewall (default: don't touch the firewall)"
    exit 1
fi

case "$DNS" in
    current|cloudflare|google|opendns|verisign) ;;
    *) echo "ERROR: Invalid DNS selection: $DNS"; exit 1;;
esac

if [[ $OPERATION == none ]]; then
    echo "ERROR: You must specify an operation"
    exit 1
fi

if [[ $OPERATION == adduser ]]; then
    if [[ -z $CLIENT ]]; then
        echo "ERROR: User name is empty"
        exit 1
    fi
fi

if [[ $OPERATION == rmuser ]]; then
    if [[ -z $CLIENT ]]; then
        echo "ERROR: User name is empty"
        exit 1
    else
	echo "$CLIENT"
    fi
fi


log() {
    echo SCRIPT "$@"
}

#######################
# Convert format mask #
#######################

cdr2mask () {
   # Number of args to shift, 255..255, first non-255 byte, zeroes
   set -- $(( 5 - ($1 / 8) )) 255 255 255 255 $(( (255 << (8 - ($1 % 8))) & 255 )) 0 0 0
   [ $1 -gt 1 ] && shift $1 || shift
   echo ${1-0}.${2-0}.${3-0}.${4-0}
}

cdrtomask () {
   if [[ $1 =~ "/" ]]; then
    NET=$(echo "$1" | cut -d "/" -f1)
   	mask=$(echo "$1" | cut -d "/" -f2)
   else
   	mask=$1
   fi
   MASK=$(cdr2mask $mask)
   echo "$NET $MASK"
}

######################
# Run various checks #
######################

# Detect Debian users running the script with "sh" instead of bash
if readlink /proc/$$/exe | grep -q "dash"; then
    echo "ERROR: This script needs to be run with bash, not sh"
    exit 1
fi

if [[ "$EUID" -ne 0 ]]; then
    echo "ERROR: Sorry, you need to run this as root"
    exit 1
fi

if [[ ! -e /dev/net/tun ]]; then
    echo "ERROR: The TUN device is not available"
    echo "You need to enable TUN before running this script"
    exit 1
fi

if [[ -e /etc/debian_version ]]; then
    OS=debian
    GROUPNAME=nogroup
    RCLOCAL='/etc/rc.local'
    export DEBIAN_FRONTEND=noninteractive

elif [[ -e /etc/centos-release || -e /etc/redhat-release || -e /etc/system-release ]]; then
    OS=centos
    GROUPNAME=nobody
    RCLOCAL='/etc/rc.d/rc.local'

else
    echo "ERROR: Looks like you aren't running this installer on Debian,"
    echo "Ubuntu, RedHat, CentOS or Amazon Linux"
    exit 1
fi

log "Detected OS: $OS"

########################
# Update NetworkFormat #
########################

NETWORKFORMAT=$(cdrtomask $NETWORK)


###################
# Refresh OpenVPN #
###################

if [[ $OPERATION == refresh ]]; then
    if [[ $OS == debian ]]; then
        apt-get -q -y update
        apt-get -q -y install openvpn openssl ca-certificates
        if [[ $FIREWALL == yes ]]; then
            apt-get -q -y iptables
        fi

    else
        yum -q -y install epel-release
        yum -q -y install openvpn openssl ca-certificates
        if [[ $FIREWALL == yes ]]; then
            yum -q -y install iptables
        fi
    fi

    # Enable net.ipv4.ip_forward for the system
    echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/30-openvpn-forward.conf

    # Enable without waiting for a reboot or service restart
    echo 1 > /proc/sys/net/ipv4/ip_forward

    # If SELinux is enabled and a custom port was selected, we need this
    if sestatus 2>/dev/null | grep "Current mode" | grep -q "enforcing" && [[ "$PORT" != '1194' ]]; then
        # Install semanage if not already present
        if ! hash semanage 2>/dev/null; then
            yum install policycoreutils-python -y
        fi
        semanage port -a -t openvpn_port_t -p $PROTOCOL $PORT
    fi

    # And finally, restart OpenVPN
    if [[ "$OS" = 'debian' ]]; then
        # Little hack to check for systemd
        if pgrep systemd-journal; then
            systemctl restart openvpn@server.service
        else
            /etc/init.d/openvpn restart
        fi
    else
        if pgrep systemd-journal; then
            systemctl restart openvpn@server.service
            systemctl enable openvpn@server.service
        else
            service openvpn restart
            chkconfig openvpn on
        fi
    fi

    log "OpenVPN successfully refreshed"
    exit 0
fi


#################################
# Install and configure OpenVPN #
#################################

if [[ $OPERATION == install ]]; then
    if [[ $OS == debian ]]; then
        apt-get -q -y update
        apt-get -q -y install openvpn openssl ca-certificates
        if [[ $FIREWALL == yes ]]; then
            apt-get -q -y iptables
        fi

    else
	amazon-linux-extras install -y epel
        yum -q -y install epel-release
        yum -q -y install openvpn openssl ca-certificates
        # if [[ $FIREWALL == yes ]]; then
            # yum -q -y install iptables
        # fi
    fi

    # Get easy-rsa
    EASYRSAURL='https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.6/EasyRSA-unix-v3.0.6.tgz'
    wget -O ~/easyrsa.tgz "$EASYRSAURL" 2>/dev/null \
        || curl -Lo ~/easyrsa.tgz "$EASYRSAURL"
    tar xzf ~/easyrsa.tgz -C ~/
    mv ~/EasyRSA-v3.0.6/ /etc/openvpn/
    mv /etc/openvpn/EasyRSA-v3.0.6/ /etc/openvpn/easy-rsa/
    chown -R root:root /etc/openvpn/easy-rsa/
    rm -f ~/easyrsa.tgz
    cd /etc/openvpn/easy-rsa/

    # Create the PKI, set up the CA and the server and client certificates
    ./easyrsa init-pki
    ./easyrsa --batch build-ca nopass
    EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-server-full server nopass
    EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl

    # Move the stuff we need
    cp pki/ca.crt pki/private/ca.key pki/issued/server.crt \
        pki/private/server.key pki/crl.pem /etc/openvpn

    # CRL is read with each client connection, when OpenVPN is dropped to nobody
    chown nobody:$GROUPNAME /etc/openvpn/crl.pem

    # Generate key for tls-auth
    openvpn --genkey --secret /etc/openvpn/ta.key

    # Create the DH parameters file using the predefined ffdhe2048 group
    echo '-----BEGIN DH PARAMETERS-----
MIIBCAKCAQEA//////////+t+FRYortKmq/cViAnPTzx2LnFg84tNpWp4TZBFGQz
+8yTnc4kmz75fS/jY2MMddj2gbICrsRhetPfHtXV/WVhJDP1H18GbtCFY2VVPe0a
87VXE15/V8k1mE8McODmi3fipona8+/och3xWKE2rec1MKzKT0g6eXq8CrGCsyT7
YdEIqUuyyOP7uWrat2DX9GgdT0Kj3jlN9K5W7edjcrsZCwenyO4KbXCeAvzhzffi
7MA0BM0oNC9hkXL+nOmFg/+OTxIy7vKBg8P+OxtMb61zO7X8vC7CIAXFjvGDfRaD
ssbzSibBsu/6iGtCOGEoXJf//////////wIBAg==
-----END DH PARAMETERS-----' > /etc/openvpn/dh.pem

    # Generate server.conf
    echo "port $PORT
proto $PROTOCOL
dev tun
sndbuf 0
rcvbuf 0
ca ca.crt
cert server.crt
key server.key
dh dh.pem
tls-server
tls-auth /etc/openvpn/keys/static.key 0
tls-version-min 1.2
tls-cipher TLS-ECDHE-RSA-WITH-AES-128-GCM-SHA256:TLS-ECDHE-ECDSA-WITH-AES-128-GCM-SHA256:TLS-ECDHE-RSA-WITH-AES-256-GCM-SHA384:TLS-DHE-RSA-WITH-AES-256-CBC-SHA256
auth SHA512
tls-auth ta.key 0
topology subnet
server 172.18.22.0 255.255.255.0
ifconfig-pool-persist ipp.txt" > /etc/openvpn/server.conf
    # add route the network access
    echo 'push "route 10.36.24.0 255.255.248.0"' >> /etc/openvpn/server.conf
    echo 'push "route 10.36.16.0 255.255.248.0"' >> /etc/openvpn/server.conf
    echo 'push "route 10.36.8.0 255.255.254.0"' >> /etc/openvpn/server.conf
    # Route all traffic to internet
    #echo 'push "redirect-gateway def1 bypass-dhcp"' >> /etc/openvpn/server.conf

    # DNS
    case $DNS in
        current)
            # Locate the proper resolv.conf
            # Needed for systems running systemd-resolved
            if grep -q "127.0.0.53" "/etc/resolv.conf"; then
                RESOLVCONF='/run/systemd/resolve/resolv.conf'
            else
                RESOLVCONF='/etc/resolv.conf'
            fi
            # Obtain the resolvers from resolv.conf and use them for OpenVPN
            grep -v '#' $RESOLVCONF | grep 'nameserver' | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | while read line; do
                echo "push \"dhcp-option DNS $line\"" >> /etc/openvpn/server.conf
            done
            ;;

        cloudflare)
            echo 'push "dhcp-option DNS 1.1.1.1"' >> /etc/openvpn/server.conf
            echo 'push "dhcp-option DNS 1.0.0.1"' >> /etc/openvpn/server.conf
            ;;

        google)
            echo 'push "dhcp-option DNS 8.8.8.8"' >> /etc/openvpn/server.conf
            echo 'push "dhcp-option DNS 8.8.4.4"' >> /etc/openvpn/server.conf
            ;;

        opendns)
            echo 'push "dhcp-option DNS 208.67.222.222"' >> /etc/openvpn/server.conf
            echo 'push "dhcp-option DNS 208.67.220.220"' >> /etc/openvpn/server.conf
            ;;

        verisign)
            echo 'push "dhcp-option DNS 64.6.64.6"' >> /etc/openvpn/server.conf
            echo 'push "dhcp-option DNS 64.6.65.6"' >> /etc/openvpn/server.conf
            ;;
    esac

    echo "keepalive 10 120
ping-timer-rem
cipher AES-256-CBC
user nobody
group $GROUPNAME
persist-key
persist-tun
status openvpn-status.log
log-append /var/log/openvpn.log
verb 3
max-clients 100
crl-verify crl.pem" >> /etc/openvpn/server.conf

    # Enable net.ipv4.ip_forward for the system
    echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/30-openvpn-forward.conf

    # Enable without waiting for a reboot or service restart
    echo 1 > /proc/sys/net/ipv4/ip_forward

    # If SELinux is enabled and a custom port was selected, we need this
    if sestatus 2>/dev/null | grep "Current mode" | grep -q "enforcing" && [[ "$PORT" != '1194' ]]; then
        # Install semanage if not already present
        if ! hash semanage 2>/dev/null; then
            yum install policycoreutils-python -y
        fi
        semanage port -a -t openvpn_port_t -p $PROTOCOL $PORT
    fi

    # And finally, restart OpenVPN
    if [[ "$OS" = 'debian' ]]; then
        # Little hack to check for systemd
        if pgrep systemd-journal; then
            systemctl restart openvpn@server.service
        else
            /etc/init.d/openvpn restart
        fi
    else
        if pgrep systemd-journal; then
            systemctl restart openvpn@server.service
            systemctl enable openvpn@server.service
        else
            service openvpn restart
            chkconfig openvpn on
        fi
    fi

    # client-common.txt is created so we have a template to add further users later
    echo "client
dev tun
proto $PROTOCOL
sndbuf 0
rcvbuf 0
remote $PUBLICIP $PORT
resolv-retry infinite
nobind
persist-key
persist-tun
server 172.18.22.0 255.255.255.0
push "route-gateway 172.18.22.1"
push "route $NETWORKFORMAT"
redirect-gateway def1
remote-cert-tls server
auth SHA512
cipher AES-256-CBC
setenv opt block-outside-dns
key-direction 1
verb 3" > /etc/openvpn/client-common.txt

    log "OpenVPN successfully installed and configured"
    openvpnbackup=$(aws s3 ls s3://${s3devsysops}/sysops/bastion/openvpn/backup/server.conf)
    if [[ ! -z "$openvpnbackup" ]]; then
	aws s3 cp s3://${s3devsysops}/sysops/bastion/openvpn/backup /etc/openvpn --recursive --quiet 
        if [[ "$OS" = 'debian' ]]; then
        	# Little hack to check for systemd
        	if pgrep systemd-journal; then
            		systemctl restart openvpn@server.service
        	else
            		/etc/init.d/openvpn restart
        	fi
    	else
        	if pgrep systemd-journal; then
            		systemctl restart openvpn@server.service
            		systemctl enable openvpn@server.service
        	else
            		service openvpn restart
            		chkconfig openvpn on
        	fi
    	fi	
    fi
    exit 0
fi


#####################
# Uninstall OpenVPN #
#####################

if [[ $OPERATION == uninstall ]]; then
    PORT=$(grep '^port ' /etc/openvpn/server.conf | cut -d " " -f 2)
    PROTOCOL=$(grep '^proto ' /etc/openvpn/server.conf | cut -d " " -f 2)

    if sestatus 2>/dev/null | grep "Current mode" | grep -q "enforcing" && [[ "$PORT" != '1194' ]]; then
        semanage port -d -t openvpn_port_t -p $PROTOCOL $PORT
    fi

    if [[ "$OS" = 'debian' ]]; then
        apt-get -q -y remove --purge openvpn
    else
        yum -q -y remove openvpn
    fi

    rm -rf /etc/openvpn
    rm -f /etc/sysctl.d/30-openvpn-forward.conf
    # Pendiente de eliminar s3://${s3devsysops}/sysops/bastion/openvpn/backup 
    log "OpenVPN uninstalled"
    exit 0
fi

#################################
# Function to create a new user #
#################################

newclient () {
    # Generates the custom client.ovpn
    file="/etc/openvpn/$1.ovpn"
    cp /etc/openvpn/client-common.txt "$file"
    echo "<ca>" >> "$file"
    cat /etc/openvpn/easy-rsa/pki/ca.crt >> "$file"
    echo "</ca>" >> "$file"
    echo "<cert>" >> "$file"
    sed -ne '/BEGIN CERTIFICATE/,$ p' \
        "/etc/openvpn/easy-rsa/pki/issued/$1.crt" >> "$file"
    echo "</cert>" >> "$file"
    echo "<key>" >> "$file"
    cat "/etc/openvpn/easy-rsa/pki/private/$1.key" >> "$file"
    echo "</key>" >> "$file"
    echo "<tls-auth>" >> "$file"
    sed -ne '/BEGIN OpenVPN Static key/,$ p' /etc/openvpn/ta.key >> "$file"
    echo "</tls-auth>" >> "$file"
}



##################
# Add a new user #
##################

if [[ $OPERATION == adduser ]]; then
    cd /etc/openvpn/easy-rsa/
    chmod +x easyrsa
    EASYRSA_CERT_EXPIRE=3650 
    ./easyrsa build-client-full "$CLIENT" nopass 
    #EASYRSA_CERT_EXPIRE=3650 ./easyrsa build-client-full "$CLIENT"
    newclient "$CLIENT"
    cd /etc/openvpn
    zip -P $(aws ssm get-parameter --name /users/ssh/masterkey/openvpn/bastion --with-decryption | jq ".Parameter | .Value" | cut -d "\"" -f2) ${CLIENT}-ovpn.zip ./${CLIENT}.ovpn
    aws s3 cp ./${CLIENT}-ovpn.zip s3://${s3devsysops}/sysops/bastion/openvpn/ClientCerts/
    rm -f ./${CLIENT}-ssh.ovpn
    rm -f ./${CLIENT}-ovpn.zip 
    echo "Configuration is available at: s3://${s3devsysops}/sysops/bastion/openvpn/ClientCerts/${CLIENT}-ovpn.zip"
    aws s3 sync /etc/openvpn s3://${s3devsysops}/sysops/bastion/openvpn/backup --delete --quiet
    echo "User ${CLIENT} added" 
    exit 0
fi


#################
# Remove a user #
#################

if [[ $OPERATION == rmuser ]]; then
    cd /etc/openvpn/easy-rsa/
    echo "$CLIENT"
    ls -la ./
    ./easyrsa --batch revoke $CLIENT
    EASYRSA_CRL_DAYS=3650 ./easyrsa gen-crl
    rm -f /etc/openvpn/crl.pem
    cp /etc/openvpn/easy-rsa/pki/crl.pem /etc/openvpn/crl.pem
    # CRL is read with each client connection, when OpenVPN is dropped to nobody
    chown nobody:$GROUPNAME /etc/openvpn/crl.pem
    echo
    aws s3 rm s3://${s3devsysops}/sysops/bastion/openvpn/ClientCerts/$CLIENT-ovpn.zip
    rm -f /etc/openvpn/$CLIENT.ovpn
    #echo "Configuration is available at: s3://${s3devsysops}/sysops/bastion/openvpn/ClientCerts/$CLIENT-ovpn.zip"
    aws s3 sync /etc/openvpn s3://${s3devsysops}/sysops/bastion/openvpn/backup --delete --quiet
    echo "Certificate for client $CLIENT revoked!"
    log "User revoked"
    exit 0
fi

log "ERROR: Invalid operation: $OPERATION"
exit 1