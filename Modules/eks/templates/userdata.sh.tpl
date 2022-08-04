#!/bin/bash -xe

# Allow user supplied pre userdata code
${pre_userdata}
# Setting TimeZone America/Lima
mv /etc/sysconfig/clock /etc/sysconfig/clock.old
cat <<EOF >/etc/sysconfig/clock
ZONE="America/Lima"
UTC=true
EOF
ln -sf /usr/share/zoneinfo/America/Lima /etc/localtime

# Bootstrap and join the cluster
/etc/eks/bootstrap.sh --b64-cluster-ca '${cluster_auth_base64}' --apiserver-endpoint '${endpoint}' ${bootstrap_extra_args} --kubelet-extra-args "${kubelet_extra_args}" '${cluster_name}'
yum install -y iptables-services
iptables --insert FORWARD 1 --in-interface eni+ --destination 169.254.169.254/32 --jump DROP
iptables-save | tee /etc/sysconfig/iptables 
systemctl enable --now iptables
# Allow user supplied userdata code
${additional_userdata}
