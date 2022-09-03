provider "aws" {
  region  = local.region
  profile = local.profile
}

# Datos cuenta AWS
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Sacar todos los datos de un workspace distinto.
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    profile        = var.profilebackend
    bucket         = var.s3backend
    key            = "terraform/${var.Environment}"
    region         = var.regionbackend
    encrypt        = true
    dynamodb_table = var.dynamobackend // Nombre de la tabla que almacena el estado de terraform.
  }
  workspace = "networking"
}

data "terraform_remote_state" "bastion" {
  backend = "s3"
  config = {
    profile        = var.profilebackend
    bucket         = var.s3backend
    key            = "terraform/${var.Environment}"
    region         = var.regionbackend
    encrypt        = true
    dynamodb_table = var.dynamobackend // Nombre de la tabla que almacena el estado de terraform.
  }
  workspace = "bastion"
}
/* imendozah
data "terraform_remote_state" "sns" {
  backend = "s3"
  config = {
    profile        = var.profilebackend
    bucket         = var.s3backend
    key            = "terraform/${var.Environment}"
    region         = var.regionbackend
    encrypt        = true
    dynamodb_table = var.dynamobackend // Nombre de la tabla que almacena el estado de terraform.
  }
  workspace = "sns-global"
}*/
/* imendozah
data "terraform_remote_state" "data-devops" {
  backend = "s3"
  config = {
    profile        = var.profilebackend
    bucket         = var.s3backend
    key            = "terraform/${var.Environment}"
    region         = var.regionbackend
    encrypt        = true
    dynamodb_table = var.dynamobackend // Nombre de la tabla que almacena el estado de terraform.
  }
  workspace = "data-devops"
}*/

data "aws_ami" "ubuntu-18_04" {
  most_recent = true
  owners = [var.account_canonical_ubuntu]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
        name   = "virtualization-type"
        values = ["hvm"]
  }
}

data "aws_ami" "ubuntu-20_04" {
  most_recent = true
  owners = [var.account_canonical_ubuntu]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
        name   = "virtualization-type"
        values = ["hvm"]
  }
}

# Recursos compartidos
# ramdom secret password 
resource "random_string" "session_secret" {
  length  = 32
  special = false
}

# ramdom para la generacion de multiples servicios
resource "random_string" "random" {
  length    = 4
  min_lower = 4
  special   = false
}

# Valor de key o password 
resource "random_string" "masterkey" {
  length    = 16
  min_lower = 12
  special   = true
}

# Almacenado de datos en ssm para la masterkey
module "ssm-master-pair" {
   source      = "../../Modules/ssm-parameter"
   name        = "/${var.stage}/${var.name}-${random_string.random.result}/masterkey/password"
   description = "The parameter description"
   type        = "SecureString"
   value       = random_string.masterkey.result

   tags = {
     "Terraform"           = "true"
     "Environment"         = var.stage
     "ProjectId"           = var.ProjectId
     "CostCenter"          = var.CostCenter
     "ServiceId"           = var.ServiceId
   }
}

# Creacion de Keypair para el servicio
module "aws_key_pair" {
  source              = "../../Modules/keypair"
  namespace           = "kp"
  stage               = var.stage
  name                = var.name
  attributes          = [random_string.random.result]
  delimiter           = "-"
  ssh_public_key_path = var.ssh_public_key_path
  generate_ssh_key    = var.generate_ssh_key
}

# Subida de datos a SSM de los Keypair
module "ssm-key-pair" {
   source      = "../../Modules/ssm-parameter"
   name        = "/${var.stage}/keypair/${var.name}-${random_string.random.result}/${module.aws_key_pair.key_name}/ssh-public"
   description = "The parameter description"
   type        = "SecureString"
   value       = module.aws_key_pair.private_key

   tags = {
     "Terraform"           = "true"
     "Environment"         = var.stage
     "ProjectId"           = var.ProjectId
     "CostCenter"          = var.CostCenter
     "ServiceId"           = var.ServiceId
   }
}

# Label security group
module "label_sg_this" {
    source             = "../../Modules/generate-label"
    namespace          = "sg"
    stage              = var.stage
    name               = var.name
    attributes  = ["${random_string.random.result}"]
    delimiter   = "-"

    label_order = ["stage", "name", "attributes"]

    tags = {
      "Environment"         = var.stage
      "ProjectId"           = var.ProjectId
      "CostCenter"          = var.CostCenter
      "ServiceId"           = var.ServiceId
    }
}

# Label recurso asg frontapi
module "label_this" {
    source             = "../../Modules/generate-label"
    namespace          = ""
    stage              = var.stage
    name               = var.name
    attributes  = ["${random_string.random.result}"]
    delimiter   = "-"

    label_order = ["stage", "name", "attributes"]

    tags = {
      "Environment"         = var.stage
      "ProjectId"           = var.ProjectId
      "CostCenter"          = var.CostCenter
      "ServiceId"           = var.ServiceId
      "Auto-Start"          = var.AutoStart
      "Auto-Stop"          = var.AutoStop
      "GroupApplication"    = var.name 
    }
    additional_tag_map = {
      propagate_at_launch = "true"
    }
}

# Crear roles y politicas

resource "aws_iam_role" "this_role" {
  name = "${var.name}_role_${random_string.random.result}"
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
  tags = module.label_sg_this.tags
}

resource "aws_iam_instance_profile" "this_profile" {
  name = "${var.name}_${random_string.random.result}"
  role = aws_iam_role.this_role.name
}

resource "aws_iam_role_policy" "this_policy" {
  name = "${var.name}_policy_${random_string.random.result}"
  role = aws_iam_role.this_role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "elasticbeanstalk:*",
                "ec2:*",
                "route53:*",
                "ssm:*",
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
                "arn:aws:iam::*:role/${var.name}_role*",
                "arn:aws:iam::*:instance-profile/${var.name}_role*"
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

# Security Group Bastion Devops
resource "aws_security_group" "sg_this" {
  name        = module.label_sg_this.id
  description = "Security Group de ${var.name}"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id
  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags          = module.label_sg_this.tags
  lifecycle {
    #create_before_destroy = true
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      ingress,
      egress
    ]
  }
}

resource "aws_security_group_rule" "bastion_to_this" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.sg_this.id
}
/* imendozah
resource "aws_security_group_rule" "this_to_aurora_postgres" {
  type              = "ingress"
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  source_security_group_id  = aws_security_group.sg_this.id
  security_group_id = data.terraform_remote_state.data-devops.outputs.aurora_arqref_security_group_id
}*/
/* imendozah
resource "aws_security_group_rule" "this_to_elc_redis" {
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id  = aws_security_group.sg_this.id
  security_group_id = data.terraform_remote_state.data-devops.outputs.elasticache_security_group
}*/

# locals {
#   user_data = <<EOF
# #!/bin/bash
# echo "Hello Terraform!"
# EOF
# }

module "ec2" {
  source                      = "../../Modules/ec2"
  instance_count              = 1
  name                        = module.label_this.id
  ami                         = data.aws_ami.ubuntu-20_04.id
  instance_type               = var.instance_type
  subnet_id                   = data.terraform_remote_state.networking.outputs.private_2_subnet-id[0]
  #subnet_ids                  = 
  vpc_security_group_ids      = [aws_security_group.sg_this.id]
  associate_public_ip_address = false
  #placement_group            =
  user_data                   = data.template_cloudinit_config.cloud-init.rendered
  #user_data_base64            = base64encode(local.user_data)
  #user_data_base64            = base64encode(data.template_cloudinit_config.cloud-init.rendered)
  #encrypted                   = "true"
  key_name                    = module.aws_key_pair.key_name
  monitoring                  = true
  iam_instance_profile        = aws_iam_instance_profile.this_profile.name
  source_dest_check           = true
  disable_api_termination     = false
  root_block_device           = [
    {
      volume_type = "gp2"
      volume_size = 20
      delete_on_termination = false
      encrypted = true
    }
  ]

  # ebs_block_device = [
  #   {
  #     device_name = "/dev/sdf"
  #     volume_type = "gp2"
  #     volume_size = 5
  #     encrypted   = true
  #     kms_key_id  = aws_kms_key.this.arn
  #   }
  # ]

  tags = module.label_this.tags
  # lifecycle {
  #       create_before_destroy = true
  # }
}
/* imendozah
resource "aws_route53_record" "host-variable" {
  #count = var.zone_name == "" ? 0 : 1  
  zone_id = data.terraform_remote_state.networking.outputs.internal_service_domain_id[0]
  name    = module.label_this.id
  type    = "A"
  ttl     = "60"
  records = module.ec2.private_ip
}

resource "aws_route53_record" "host" {
  #count = var.zone_name == "" ? 0 : 1  
  zone_id = data.terraform_remote_state.networking.outputs.internal_service_domain_id[0]
  name    = "${var.stage}-${var.name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${module.label_this.id}.${data.terraform_remote_state.networking.outputs.internal_service_domain}"]
}*/






