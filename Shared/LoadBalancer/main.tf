data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    profile        = var.BackendProfile
    bucket         = var.BackendS3
    key            = "terraform/${var.Environment}"
    region         = var.BackendRegion
    encrypt        = true
    dynamodb_table = var.BackendDynamoDB // Nombre de la tabla que almacena el estado de terraform.
  }
  workspace = "networking"
}

data "terraform_remote_state" "kubernetes-pro" {
  backend = "s3"
  config = {
    profile        = var.BackendProfile
    bucket         = var.BackendS3
    key            = "terraform/${var.EnvironmentPro}"
    region         = var.BackendRegion
    encrypt        = true
    dynamodb_table = var.BackendDynamoDB // Nombre de la tabla que almacena el estado de terraform.
  }
  workspace = "kubernetes"
}

data "terraform_remote_state" "bastion" {
  backend = "s3"
  config = {
    profile        = var.BackendProfile
    bucket         = var.BackendS3
    key            = "terraform/${var.Environment}"
    region         = var.BackendRegion
    encrypt        = true
    dynamodb_table = var.BackendDynamoDB // Nombre de la tabla que almacena el estado de terraform.
  }
  workspace = "bastion"
}

data "terraform_remote_state" "bastion-devops" {
  backend = "s3"
  config = {
    profile        = var.BackendProfile
    bucket         = var.BackendS3
    key            = "terraform/${var.Environment}"
    region         = var.BackendRegion
    encrypt        = true
    dynamodb_table = var.BackendDynamoDB // Nombre de la tabla que almacena el estado de terraform.
  }
  workspace = "bastion-devops"
}

data "aws_ami" "linux_ami" {
  most_recent = true
  owners = [element(split(";", var.ami_id_filter[var.linux_distro]), 1)]

  filter {
    name   = "name"
    values = [element(split(";", var.ami_id_filter[var.linux_distro]), 0)]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
        name   = "virtualization-type"
        values = ["hvm"]
  }
}

resource "random_string" "random" {
  length    = 4
  min_lower = 4
  special   = false
}

resource "aws_iam_role" "loadbalancer_role" {
  name               = "loadbalancer-role-${random_string.random.result}"
  assume_role_policy = file("role_policy/assume-role-policy.json")
  tags = {
    Name         = "loadbalancer-role-${random_string.random.result}"
    Owner        = var.Owner
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
  }
}

resource "aws_iam_policy" "loadbalancer_policy" {
  name   = "loadbalancer-policy-${random_string.random.result}"
  policy = file("role_policy/policy-s3-bucket.json")
}

resource "aws_iam_policy_attachment" "loadbalancer_attachment" {
  name       = "loadbalancer-attachment-${random_string.random.result}"
  roles      = [aws_iam_role.loadbalancer_role.name]
  policy_arn = aws_iam_policy.loadbalancer_policy.arn
}

resource "aws_iam_instance_profile" "loadbalancer_profile" {
  name  = "loadbalancer-profile-${random_string.random.result}"
  role = aws_iam_role.loadbalancer_role.name
}

# Creacion de Keypair para el servicio
module "aws_key_pair" {
  source              = "../../Modules/keypair"
  namespace           = "kp"
  stage               = var.Environment
  name                = "kp-${var.Environment}-loadbalancer-${random_string.random.result}"
  attributes          = [random_string.random.result]
  delimiter           = "-"
  ssh_public_key_path = "./secret"
  generate_ssh_key    = true
}

# Subida de datos a SSM de los Keypair
module "ssm-key-pair" {
   source      = "../../Modules/ssm-parameter"
   name        = "/${var.Environment}/keypair/loadbalancer-${random_string.random.result}/${module.aws_key_pair.key_name}/ssh-public"
   description = "The parameter description"
   type        = "SecureString"
   value       = module.aws_key_pair.private_key

   tags = {
     "Terraform"           = "true"
     "Environment"         = var.Environment
     "ProjectId"           = var.ProjectId
     "CostCenter"          = var.CostCenter
     "ServiceId"           = var.ServiceId
   }
}

resource "aws_security_group" "access" {
  name        = "${var.Environment}-loadbalancer-${random_string.random.result}"
  description = "Allow traffic for custom"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "${var.Environment}-loadbalancer-${random_string.random.result}"
    Owner        = var.Owner
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
  }
}

resource "aws_security_group_rule" "bastion-devops_to_loadbalancer_ssh" {
  type              = "ingress"
  from_port         = local.ssh_port
  to_port           = local.ssh_port
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion-devops.outputs.security_group_id
  security_group_id = aws_security_group.access.id
  description = "Loadbalancer ssh communication from Bastion DevOps"
}

resource "aws_security_group_rule" "bastion_to_loadbalancer_ssh" {
  type              = "ingress"
  from_port         = local.ssh_port
  to_port           = local.ssh_port
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.access.id
  description = "Loadbalancer ssh communication from Bastion"
}

resource "aws_security_group_rule" "bastion_to_loadbalancer_http" {
  type              = "ingress"
  from_port         = local.http_port
  to_port           = local.http_port
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.access.id
  description = "Loadbalancer http communication from Bastion"
}

resource "aws_security_group_rule" "bastion_to_loadbalancer_https" {
  type              = "ingress"
  from_port         = local.https_port
  to_port           = local.https_port
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.access.id
  description = "Loadbalancer https communication from Bastion"
}

resource "aws_security_group_rule" "all_to_loadbalancer_http" {
  type              = "ingress"
  from_port         = local.http_port
  to_port           = local.http_port
  protocol          = local.protocol_tcp
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.access.id
  description = "Loadbalancer http communication from All"
}

resource "aws_security_group_rule" "all_to_loadbalancer_https" {
  type              = "ingress"
  from_port         = local.https_port
  to_port           = local.https_port
  protocol          = local.protocol_tcp
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.access.id
  description = "Loadbalancer https communication from All"
}

resource "aws_security_group_rule" "loadbalancer_all_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.access.id
  description = "ALL port communication from Loadbalancer"
}

resource "aws_security_group_rule" "k8s_pro_to_loadbalancer_http" {
  type              = "ingress"
  from_port         = local.http_port
  to_port           = local.http_port
  protocol          = local.protocol_tcp
  source_security_group_id  = element(data.terraform_remote_state.kubernetes-pro.outputs.server_security_group_id, 0)
  security_group_id = aws_security_group.access.id
  description = "Loadbalancer communication from K8s Pro Http"
}

resource "aws_security_group_rule" "k8s_pro_to_loadbalancer_https" {
  type              = "ingress"
  from_port         = local.https_port
  to_port           = local.https_port
  protocol          = local.protocol_tcp
  source_security_group_id  = element(data.terraform_remote_state.kubernetes-pro.outputs.server_security_group_id, 0)
  security_group_id = aws_security_group.access.id
  description = "Loadbalancer communication from K8s Pro Https"
}

resource "aws_instance" "server" {
  count                       = var.Instances
  ami                         = data.aws_ami.linux_ami.id
  instance_type               = var.InstanceType
  subnet_id                   = element(data.terraform_remote_state.networking.outputs.nat-subnet-id, 0)
  vpc_security_group_ids      = [aws_security_group.access.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.loadbalancer_profile.name
  key_name                    = module.aws_key_pair.key_name
  tags = {
    Name         = "${var.Environment}-loadbalancer_${var.linux_distro}_${var.Instances}-${random_string.random.result}-${count.index}"
    Owner        = var.Owner
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
    Auto-Start   = var.AutoStart
    Auto-Stop    = var.AutoStop
  }
}

resource "aws_route53_record" "private_dns" {
  count   = var.Instances
  zone_id = data.terraform_remote_state.networking.outputs.internal_service_domain_id[0]
  name    = "${var.Environment}-loadbalancer-${count.index}.${data.terraform_remote_state.networking.outputs.internal_service_domain}"
  type    = "A"
  ttl     = "60"
  records = [element(aws_instance.server.*.private_ip, count.index)]
}