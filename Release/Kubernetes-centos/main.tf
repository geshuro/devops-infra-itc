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

data "terraform_remote_state" "networking-shared" {
  backend = "s3"
  config = {
    profile        = var.BackendProfile
    bucket         = var.BackendS3
    key            = "terraform/shared"
    region         = var.BackendRegion
    encrypt        = true
    dynamodb_table = var.BackendDynamoDB // Nombre de la tabla que almacena el estado de terraform.
  }
  workspace = "networking"
}

data "terraform_remote_state" "bastion" {
  backend = "s3"
  config = {
    profile        = var.BackendProfile
    bucket         = var.BackendS3
    key            = "terraform/shared"
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
    key            = "terraform/shared"
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

resource "aws_iam_role" "kubernetes_role" {
  name               = "kubernetes-role-${random_string.random.result}"
  assume_role_policy = file("role_policy/assume-role-policy.json")
  tags = {
    Name         = "kubernetes-role-${random_string.random.result}"
    Owner        = var.Owner
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
  }
}

resource "aws_iam_policy" "kubernetes_policy" {
  name   = "kubernetes-policy-${random_string.random.result}"
  policy = file("role_policy/policy-s3-bucket.json")
}

resource "aws_iam_policy_attachment" "kubernetes_attachment" {
  name       = "kubernetes-attachment-${random_string.random.result}"
  roles      = [aws_iam_role.kubernetes_role.name]
  policy_arn = aws_iam_policy.kubernetes_policy.arn
}

resource "aws_iam_instance_profile" "kubernetes_profile" {
  name  = "kubernetes-profile-${random_string.random.result}"
  role = aws_iam_role.kubernetes_role.name
}

# Creacion de Keypair para el servicio
module "aws_key_pair" {
  source              = "../../Modules/keypair"
  namespace           = "kp"
  stage               = var.Environment
  name                = "kp-${var.Environment}-kubernetes-${random_string.random.result}"
  attributes          = [random_string.random.result]
  delimiter           = "-"
  ssh_public_key_path = "./secret"
  generate_ssh_key    = true
}

# Subida de datos a SSM de los Keypair
module "ssm-key-pair" {
   source      = "../../Modules/ssm-parameter"
   name        = "/${var.Environment}/keypair/kubernetes-${random_string.random.result}/${module.aws_key_pair.key_name}/ssh-public"
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

resource "aws_security_group" "kubernetes_access" {
  name        = "${var.Environment}-kubernetes-${random_string.random.result}"
  description = "Allow traffic for custom PaaS of Kubernetes"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "${var.Environment}-kubernetes-${random_string.random.result}"
    Owner        = var.Owner
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
  }
}

resource "aws_security_group_rule" "bastion-devops_to_kubernetes_ssh" {
  type              = "ingress"
  from_port         = local.ssh_port
  to_port           = local.ssh_port
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion-devops.outputs.security_group_id
  security_group_id = aws_security_group.kubernetes_access.id
  description = "Kubernetes ssh communication from Bastion DevOps"
}

resource "aws_security_group_rule" "bastion_to_kubernetes_ssh" {
  type              = "ingress"
  from_port         = local.ssh_port
  to_port           = local.ssh_port
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.kubernetes_access.id
  description = "Kubernetes ssh communication from Bastion DevOps"
}

resource "aws_security_group_rule" "kubernetes_api_server_self" {
  type              = "ingress"
  from_port         = local.kubernetes_api_server_port
  to_port           = local.kubernetes_api_server_port
  protocol          = local.protocol_tcp
  self              = true
  security_group_id = aws_security_group.kubernetes_access.id
  description = "API Server port communication from Kubernetes"
}

resource "aws_security_group_rule" "kubernetes_all_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.kubernetes_access.id
  description = "ALL port communication from Kubernetes"
}

resource "aws_instance" "kubernetes_server" {
  count                       = var.KubernetesInstances
  ami                         = data.aws_ami.linux_ami.id
  instance_type               = var.KubernetesInstanceType
  subnet_id                   = element(data.terraform_remote_state.networking.outputs.private_2_subnet-id, 0)
  vpc_security_group_ids      = [aws_security_group.kubernetes_access.id]
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.kubernetes_profile.name
  key_name                    = module.aws_key_pair.key_name
  tags = {
    Name         = "${var.Environment}-k8s_${var.linux_distro}_${var.KubernetesInstances}-${random_string.random.result}-${count.index}"
    Owner        = var.Owner
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
    Auto-Start   = var.AutoStart
    Auto-Stop    = var.AutoStop
  }
  /* imendozah
  volume_tags = {
    Name         = "${var.Environment}-k8s_${var.linux_distro}_${var.KubernetesInstances}-${random_string.random.result}-${count.index}"
    Owner        = var.Owner
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
  }
  
  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = var.DiskSizeKubernetesData
    volume_type           = "gp2"
    delete_on_termination = true
  }*/

  #user_data = data.template_cloudinit_config.kubernetes_configuration[count.index].rendered
}

resource "aws_ebs_volume" "kubernetes_ebs" {
  count             = var.KubernetesInstances
  availability_zone = var.AvailabilityZoneEBS
  size              = var.DiskSizeKubernetesDataEBS
  type              = "gp2"
  tags = {
    Name = "Kubernetes release"
  }
}

resource "aws_volume_attachment" "kubernetes_ebs" {
  count   = var.KubernetesInstances
  device_name = "/dev/sdb"
  volume_id   = element(aws_ebs_volume.kubernetes_ebs.*.id, count.index)
  instance_id = element(aws_instance.kubernetes_server.*.id, count.index)
}

resource "aws_route53_record" "kubernetes_private_dns" {
  count   = var.KubernetesInstances
  zone_id = data.terraform_remote_state.networking-shared.outputs.internal_service_domain_id[0]
  name    = "${var.Environment}-k8s-${count.index}.${data.terraform_remote_state.networking-shared.outputs.internal_service_domain}"
  type    = "A"
  ttl     = "60"
  records = [element(aws_instance.kubernetes_server.*.private_ip, count.index)]
}