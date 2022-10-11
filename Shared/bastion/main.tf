provider "aws" {
  profile = local.profile
  region  = local.region
}

# Datos cuenta AWS
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Sacar todos los datos de un workspace distinto.
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    profile        = var.profile
    bucket         = var.s3backend
    key            = var.key
    region         = var.region
    encrypt        = true
    dynamodb_table = var.dynamodb_table // Nombre de la tabla que almacena el estado de terraform.
  }
  workspace = "networking"
}

resource "random_string" "random" {
  length    = 4
  min_lower = 4
  special   = false
}

resource "random_string" "masterkey" {
  length    = 16
  min_lower = 12
  special   = true
}

module "ssm-master-pair" {
  source      = "../../Modules/ssm-parameter"
  name        = "/users/ssh/masterkey/openvpn/bastion"
  description = "The parameter description"
  type        = "SecureString"
  value       = random_string.masterkey.result

  tags = {
    "Terraform"   = "true"
    "Environment" = var.stage
    "ProjectId"   = var.ProjectId
    "CostCenter"  = var.CostCenter
    "ServiceId"   = var.ServiceId
  }
}

module "aws_key_pair" {
  source              = "../../Modules/keypair"
  namespace           = "kp"
  stage               = var.stage
  name                = var.name
  ssh_public_key_path = var.ssh_public_key_path
  generate_ssh_key    = var.generate_ssh_key
}

module "ssm-key-pair" {
  source      = "../../Modules/ssm-parameter"
  name        = "/${var.stage}/keypair/${module.aws_key_pair.key_name}/ssh-public"
  description = "The parameter description"
  type        = "SecureString"
  value       = module.aws_key_pair.private_key

  tags = {
    "Terraform"   = "true"
    "Environment" = var.stage
    "ProjectId"   = var.ProjectId
    "CostCenter"  = var.CostCenter
    "ServiceId"   = var.ServiceId
  }
}

module "label-sg-bation" {
  source     = "../../Modules/generate-label"
  namespace  = "sg"
  stage      = var.stage
  name       = var.name
  attributes = ["001"]
  delimiter  = "-"

  label_order = ["stage", "name"]

  tags = {
    "Environment" = var.stage
    "ProjectId"   = var.ProjectId
    "CostCenter"  = var.CostCenter
    "ServiceId"   = var.ServiceId
  }
}

module "sg-bastion-ssh" {
  source = "../../Modules/sg/modules/ssh"

  create              = true
  name                = module.label-sg-bation.id
  use_name_prefix     = true
  description         = "Security Group de Bastion"
  vpc_id              = data.terraform_remote_state.networking.outputs.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  tags                = module.label-sg-bation.tags
  # Add MySQL rules
  ingress_rules = ["openvpn-tcp", "openvpn-udp", "openvpn-https-tcp"]
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "image-type"
    values = ["machine"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "hypervisor"
    values = ["xen"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
# ami                         = "${data.aws_ami.amazon-linux-2.id}"

module "label-asg-bastion" {
  source     = "../../Modules/generate-label"
  namespace  = "asg"
  stage      = var.stage
  name       = var.name
  attributes = [random_string.random.result]
  delimiter  = "-"

  label_order = ["namespace", "stage", "name", "attributes"]

  tags = {
    "Environment" = var.stage
    "ProjectId"   = var.ProjectId
    "CostCenter"  = var.CostCenter
    "ServiceId"   = var.ServiceId
  }
  additional_tag_map = {
    propagate_at_launch = "true"
  }
}
# Crear IAM Role de instancias
data "aws_iam_policy_document" "bastion-policy" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticbeanstalk:*",
      "ec2:*",
      "ecs:*",
      "ecr:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "cloudwatch:*",
      "s3:*",
      "sns:*",
      "cloudformation:*",
      "dynamodb:*",
      "rds:*",
      "sqs:*",
      "logs:*",
      "iam:GetPolicyVersion",
      "iam:GetRole",
      "iam:PassRole",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfiles",
      "iam:ListRoles",
      "iam:ListServerCertificates",
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "codebuild:CreateProject",
      "codebuild:DeleteProject",
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]
  }
  statement {
    sid       = ""
    effect    = "Allow"
    resources = [module.ssm-master-pair.ssm-path-arn]
    actions = [
      "ssm:GetParameters",
      "ssm:GetParameter",
    ]
  }

  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:iam::*:role/bastion_role*",
      "arn:aws:iam::*:instance-profile/bastion_role*",
    ]

    actions = [
      "iam:AddRoleToInstanceProfile",
      "iam:CreateInstanceProfile",
      "iam:CreateRole",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:iam::*:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling*"]
    actions   = ["iam:CreateServiceLinkedRole"]

    condition {
      test     = "StringLike"
      variable = "iam:AWSServiceName"
      values   = ["autoscaling.amazonaws.com"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:iam::*:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing*"]
    actions   = ["iam:CreateServiceLinkedRole"]

    condition {
      test     = "StringLike"
      variable = "iam:AWSServiceName"
      values   = ["elasticloadbalancing.amazonaws.com"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:iam::*:role/bastion-role*"]
    actions   = ["iam:AttachRolePolicy"]

    condition {
      test     = "StringLike"
      variable = "iam:PolicyArn"

      values = [
        "arn:aws:iam::aws:policy/bastion-policy*",
        "arn:aws:iam::aws:policy/service-role/bastion-policy*",
      ]
    }
  }
}

data "aws_iam_policy_document" "bastion-service-role" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "bastion_role" {
  name               = "bastion_role_${random_string.random.result}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags               = module.label-asg-bastion.tags
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name = "bastion_profile_${random_string.random.result}"
  role = aws_iam_role.bastion_role.name
}

resource "aws_iam_role_policy" "bastion_policy" {
  name   = "bastion_policy_${random_string.random.result}"
  role   = aws_iam_role.bastion_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "elasticbeanstalk:*",
                "ec2:*",
                "ecs:*",
                "ecr:*",
                "elasticloadbalancing:*",
                "autoscaling:*",
                "cloudwatch:*",
                "s3:*",
                "sns:*",
                "cloudformation:*",
                "dynamodb:*",
                "rds:*",
                "sqs:*",
                "logs:*",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "iam:ListUsers",
                "iam:GetGroup",
                "iam:PassRole",
                "iam:ListRolePolicies",
                "iam:ListAttachedRolePolicies",
                "iam:ListInstanceProfiles",
                "iam:ListRoles",
                "iam:ListServerCertificates",
                "acm:DescribeCertificate",
                "acm:ListCertificates",
                "codebuild:CreateProject",
                "codebuild:DeleteProject",
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameters",
                "ssm:GetParameter"
            ],
            "Resource": [
                "${module.ssm-master-pair.ssm-path-arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:GetSSHPublicKey",
                "iam:ListSSHPublicKeys"
            ],
            "Resource": [
                "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:AddRoleToInstanceProfile",
                "iam:CreateInstanceProfile",
                "iam:CreateRole"
            ],
            "Resource": [
                "arn:aws:iam::*:role/bastion_role*",
                "arn:aws:iam::*:instance-profile/bastion_role*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": [
                "arn:aws:iam::*:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling*"
            ],
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": "autoscaling.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": [
                "arn:aws:iam::*:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing*"
            ],
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": "elasticloadbalancing.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:AttachRolePolicy"
            ],
            "Resource": "arn:aws:iam::*:role/aws-elasticbeanstalk*",
            "Condition": {
                "StringLike": {
                    "iam:PolicyArn": [
                        "arn:aws:iam::aws:policy/AWSElasticBeanstalk*",
                        "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalk*"
                    ]
                }
            }
        }
    ]
}
EOF
}
# Outputs
# id - The policy's ID.
# arn - The ARN assigned by AWS to this policy.
# description - The description of the policy.
# name - The name of the policy.
# path - The path of the policy in IAM.
# policy - The policy document. 


# Crear EIP en VPC
resource "aws_eip" "eip_bastion" {
  vpc = true 
}

resource "aws_s3_bucket_object" "fileimportuser" {
  bucket = var.s3devops
  key    = "/sysops/bastion/autossh/import_users.sh"
  source = "./package/import_users.sh"
}

resource "aws_s3_bucket_object" "rpmawsec2ssh" {
  bucket = var.s3devops
  key    = "/sysops/bastion/autossh/aws-ec2-ssh-1.9.2-1.el7.centos.noarch.rpm"
  source = "./package/aws-ec2-ssh-1.9.2-1.el7.centos.noarch.rpm"
}

resource "aws_s3_bucket_object" "filemanageopenvpn" {
  bucket = var.s3devops
  key    = "/sysops/bastion/openvpn/manage-openvpn.sh"
  source = "./package/manage-openvpn.sh"
}


resource "aws_launch_configuration" "bastion" {
  name_prefix                 = "${module.label-asg-bastion.id}-v2-"
  image_id                    = data.aws_ami.amazon-linux-2.id
  instance_type               = var.instance_type
  key_name                    = module.aws_key_pair.key_name
  security_groups             = [module.sg-bastion-ssh.this_security_group_id]
  associate_public_ip_address = true
  enable_monitoring           = true
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name
  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
    encrypted             = true
  }
  #user_data_base64 = base64encode(data.template_file.user_data.rendered)
  user_data = <<-EOF
                #!/bin/bash
                mkdir -p /root/.aws
                echo -e "[default]\nregion = ${data.aws_region.current.name}" >> /root/.aws/config
                # Associar EIP
                aws ec2 wait instance-running --instance-id $(curl http:\/\/169.254.169.254/latest/meta-data/instance-id)
                aws ec2 associate-address --instance-id $(curl http:\/\/169.254.169.254/latest/meta-data/instance-id) --allocation-id ${aws_eip.eip_bastion.id} --allow-reassociation
                s3devsysops=$(aws s3 ls | grep "${var.s3devops}" | grep "${data.aws_region.current.name}"| cut -d " " -f 3)
                # Actualizar sistema
                yum update -y
                # Instalar docker
                #yum install -y docker
                #service docker start
                #usermod -a -G docker ec2-user
                yum install -y git jq
                yum -y groupinstall "Development Tools"
                #curl -L https:\/\/github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/bin/docker-compose
                #chmod +x /usr/local/bin/docker-compose
                #systemctl enable --now docker
                # Iptables para forwarding ssh
                #iptables -t nat -C POSTROUTING -o eth0 -s 10.20.8.0/22 -j MASQUERADE 2> /dev/null
                #iptables -t nat -A POSTROUTING -o eth0 -s 10.20.8.0/22 -j MASQUERADE
                # Configurar sincronizacion de usuarios
                #rpm -i https:\/\/s3-${data.aws_region.current.name}.amazonaws.com/widdix-aws-ec2-ssh-releases-${data.aws_region.current.name}/aws-ec2-ssh-1.9.2-1.el7.centos.noarch.rpm
                aws s3 cp s3://$s3devsysops/sysops/bastion/autossh/aws-ec2-ssh-1.9.2-1.el7.centos.noarch.rpm /opt/openvpn/aws-ec2-ssh-1.9.2-1.el7.centos.noarch.rpm
                rpm -i /opt/openvpn/aws-ec2-ssh-1.9.2-1.el7.centos.noarch.rpm
                sed -i 's/IAM_AUTHORIZED_GROUPS=""/IAM_AUTHORIZED_GROUPS="ssh"/' /etc/aws-ec2-ssh.conf
                sed -i 's/SUDOERS_GROUPS=""/SUDOERS_GROUPS="ssh-admin"/' /etc/aws-ec2-ssh.conf
                sed -i 's/DONOTSYNC=1/DONOTSYNC=0/' /etc/aws-ec2-ssh.conf
                aws s3 cp  s3://$s3devsysops/sysops/bastion/autossh/import_users.sh /usr/bin/
                chmod +x /usr/bin/import_users.sh 
                #'cp' -f /usr/bin/import_users.sh  /bin/ 
                # Instalar openvpn
                amazon-linux-extras install -y epel
                mkdir -p /opt/openvpn
                echo "export NETWORK=${data.terraform_remote_state.networking.outputs.vpc_cidr_block}" > /opt/openvpn/environment.sh
                echo "export S3DEVOPS=${var.s3devops}" >> /opt/openvpn/environment.sh                
                chmod +x /opt/openvpn/environment.sh
                'cp' -f /opt/openvpn/environment.sh /etc/profile.d/
                export "NETWORK=${data.terraform_remote_state.networking.outputs.vpc_cidr_block}"
                export "S3DEVOPS=${var.s3devops}"
                aws s3 cp s3://$s3devsysops/sysops/bastion/openvpn/manage-openvpn.sh /opt/openvpn/
                chmod +x /opt/openvpn/manage-openvpn.sh
                /opt/openvpn/manage-openvpn.sh -i
                # Configurar reglas NAT
                iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
                iptables -t nat -A POSTROUTING -o tun0 -j MASQUERADE
                iptables -A INPUT -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
                iptables -A INPUT -i tun0 -m state --state RELATED,ESTABLISHED -j ACCEPT
                iptables -A FORWARD -j ACCEPT
                # Download script de descarga
                chown -R openvpn:openvpn /etc/openvpn
                chmod +x /etc/openvpn/easy-rsa/easyrsa
                # Cargar y lanzar
                /usr/bin/import_users.sh
                EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion" {
  name_prefix               = "${module.label-asg-bastion.id}-"
  max_size                  = var.max_size
  min_size                  = var.min_size
  default_cooldown          = var.cooldown
  launch_configuration      = aws_launch_configuration.bastion.name
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = "EC2"
  force_delete              = true
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = data.terraform_remote_state.networking.outputs.nat-subnet-id
  termination_policies      = ["ClosestToNextInstanceHour", "OldestInstance", "Default"]
  enabled_metrics           = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  lifecycle {
    create_before_destroy = true
  }
  tags = module.label-asg-bastion.tags_as_list_of_maps
}

# Resource Down Weekend
resource "aws_autoscaling_schedule" "bastion-down-weekend" {
  count                  = var.enabledcronweekend ? 1 : 0
  scheduled_action_name  = "bastion-down-weekend"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = var.cronweekenddown.cron
  end_time               = timeadd(timestamp(), "87600h2m") //: var.cronweekenddown.end_time//"2030-06-19T18:00:00Z"
  autoscaling_group_name = aws_autoscaling_group.bastion.name
  lifecycle {
    #create_before_destroy = true
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      start_time,
      end_time
    ]
  }
}

resource "aws_autoscaling_schedule" "bastion-up-weekend" {
  count                  = var.enabledcronweekend ? 1 : 0
  scheduled_action_name  = "bastion-up-weekend"
  min_size               = var.min_size
  max_size               = var.max_size
  desired_capacity       = var.min_size
  recurrence             = var.cronweekendup.cron           // == "" ? "6 0 * * MON" : var.cronweekendup.cron //"6 0 * * MON" // 0 23 * * MON-FRI
  end_time               = timeadd(timestamp(), "87600h5m") //: var.cronweekendup.end_time //"2030-06-19T18:00:30Z"
  autoscaling_group_name = aws_autoscaling_group.bastion.name
  lifecycle {
    #create_before_destroy = true
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      start_time,
      end_time
    ]
  }
}

#Creacion de grupos por defecto para acceso console, credentials, ssh y openvpn 

resource "aws_iam_group" "ssh" {
  name = "ssh"
  path = "/"
}

resource "aws_iam_group" "ssh-admin" {
  name = "ssh-admin"
  path = "/"
}

resource "aws_iam_group" "sysops" {
  name = "sysops"
  path = "/"
}

resource "aws_iam_group" "devops" {
  name = "devops"
  path = "/"
}

# Creacion de usuario de prueba esto debe ser un modulo aparte de operaciones

# Create usuario
resource "aws_iam_user" "user" {
  name = "imendoza-ssh"
}

# Asignarle a grupos

resource "aws_iam_user_group_membership" "user" {
  user   = aws_iam_user.user.name
  groups = [aws_iam_group.ssh.name, aws_iam_group.ssh-admin.name]
}