#!/bin/sh
# Setting Time Zome
timedatectl set-timezone Europe/Madrid
# Actualizar instance
apt upgrade && apt update
# Configurar agent cloudwatch
mkdir -p /root/.aws
echo "[default]\nregion = ${REGION}" >> /root/.aws/config
#download it
curl -o /root/amazon-cloudwatch-agent.deb https://s3.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb
#install it
dpkg -i -E /root/amazon-cloudwatch-agent.deb
usermod -aG adm cwagent
#mv /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json.jinga /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
cat <<EOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
	"logs": {
		"logs_collected": {
			"files": {
				"collect_list": [
					{
						"file_path": "/var/log/syslog",
						"log_group_name": "${LOG_GROUP_NAME}",
						"log_stream_name": "{instance_id}/syslog",
						"timestamp_format" :"%b %d %H:%M:%S"
					},
                    {
						"file_path": "/var/log/cloud-init.log",
						"log_group_name": "${LOG_GROUP_NAME}",
						"log_stream_name": "{instance_id}/cloud-init",
						"timestamp_format" :"%b %d %H:%M:%S"
					},
                    {
						"file_path": "/var/log/cloud-init-output.log",
						"log_group_name": "${LOG_GROUP_NAME}",
						"log_stream_name": "{instance_id}/cloud-init-output",
						"timestamp_format" :"%b %d %H:%M:%S"
					}
                ]
            }
        }
    }
}
EOF
systemctl enable amazon-cloudwatch-agent.service
service amazon-cloudwatch-agent start

# Se instala los siguientes paquetes, librerias y binarios
#  - kubectl
apt update
apt install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
apt update
apt install -y kubectl

#  - Ansible 2.12
apt-add-repository -y ppa:ansible/ansible
apt update
apt install -y ansible

#  - Helm 3.2.4
curl https://helm.baltorepo.com/organization/signing.asc | sudo apt-key add - 
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt update
sudo apt install -y helm
#  - Docker CE >18
apt remove docker docker-engine docker.io
apt install -y ca-certificates curl software-properties-common gnupg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
apt-key -y fingerprint 0EBFCD88
add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install -y docker-ce
usermod -aG docker ubuntu

#  - aws-iam-authenticator (necesario por eks)
curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
mv aws-iam-authenticator /usr/bin/

#  - aws -cliente
apt install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin