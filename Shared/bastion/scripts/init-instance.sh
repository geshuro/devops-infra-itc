#!/bin/bash
set -x
# Configurar region
mkdir -p /root/.aws
echo -e "[default]\nregion = ${data.aws_region.current.name}" >> /root/.aws/config
# Associar EIP
aws ec2 wait instance-running --instance-id $(curl http://169.254.169.254/latest/meta-data/instance-id)
aws ec2 associate-address --instance-id $(curl http://169.254.169.254/latest/meta-data/instance-id) --allocation-id ${aws_eip.eip_bastion.id} --allow-reassociation
# Actualizar sistema
yum update -y
# Download script de descarga
# Cargar y lanzar