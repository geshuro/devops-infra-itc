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

data "terraform_remote_state" "kubernetes-dev" {
  backend = "s3"
  config = {
    profile        = var.BackendProfile
    bucket         = var.BackendS3
    key            = "terraform/${var.Environment}"
    region         = var.BackendRegion
    encrypt        = true
    dynamodb_table = var.BackendDynamoDB // Nombre de la tabla que almacena el estado de terraform.
  }
  workspace = "kubernetes"
}

data "terraform_remote_state" "eks-shared" {
  backend = "s3"
  config = {
    profile        = var.BackendProfile
    bucket         = var.BackendS3
    key            = "terraform/shared"
    region         = var.BackendRegion
    encrypt        = true
    dynamodb_table = var.BackendDynamoDB // Nombre de la tabla que almacena el estado de terraform.
  }
  workspace = "eks-devops"
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

resource "aws_iam_role" "nfs_role" {
  name               = "nfs-role-${random_string.random.result}"
  assume_role_policy = file("role_policy/assume-role-policy.json")
  tags = {
    Name         = "nfs-role-${random_string.random.result}"
    Owner        = var.Owner
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
  }
}

resource "aws_iam_policy" "nfs_policy" {
  name   = "nfs-policy-${random_string.random.result}"
  policy = file("role_policy/policy-s3-bucket.json")
}

resource "aws_iam_policy_attachment" "nfs_attachment" {
  name       = "nfs-attachment-${random_string.random.result}"
  roles      = [aws_iam_role.nfs_role.name]
  policy_arn = aws_iam_policy.nfs_policy.arn
}

resource "aws_iam_instance_profile" "nfs_profile" {
  name  = "nfs-profile-${random_string.random.result}"
  role = aws_iam_role.nfs_role.name
}

# Creacion de Keypair para el servicio
module "aws_key_pair" {
  source              = "../../Modules/keypair"
  namespace           = "kp"
  stage               = var.Environment
  name                = "kp-${var.Environment}-nfs-${random_string.random.result}"
  attributes          = [random_string.random.result]
  delimiter           = "-"
  ssh_public_key_path = "./secret"
  generate_ssh_key    = true
}

# Subida de datos a SSM de los Keypair
module "ssm-key-pair" {
   source      = "../../Modules/ssm-parameter"
   name        = "/${var.Environment}/keypair/nfs-${random_string.random.result}/${module.aws_key_pair.key_name}/ssh-public"
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
  name        = "${var.Environment}-nfs-${random_string.random.result}"
  description = "Allow traffic for custom"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "${var.Environment}-nfs-${random_string.random.result}"
    Owner        = var.Owner
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
  }
}

resource "aws_security_group_rule" "bastion-devops_to_nfs_ssh" {
  type              = "ingress"
  from_port         = local.ssh_port
  to_port           = local.ssh_port
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion-devops.outputs.security_group_id
  security_group_id = aws_security_group.access.id
  description = "NFS ssh communication from Bastion DevOps"
}

resource "aws_security_group_rule" "bastion_to_nfs_ssh" {
  type              = "ingress"
  from_port         = local.ssh_port
  to_port           = local.ssh_port
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.access.id
  description = "NFS ssh communication from Bastion DevOps"
}

resource "aws_security_group_rule" "nfs_all_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.access.id
  description = "ALL port communication from NFS"
}

resource "aws_security_group_rule" "k8s_to_nfs" {
  type              = "ingress"
  from_port         = local.nfs_port
  to_port           = local.nfs_port
  protocol          = local.protocol_tcp
  source_security_group_id  = element(data.terraform_remote_state.kubernetes-dev.outputs.server_security_group_id, 0)
  security_group_id = aws_security_group.access.id
  description = "NFS communication from K8s"
}

resource "aws_security_group_rule" "eks_devops_to_nfs" {
  type              = "ingress"
  from_port         = local.nfs_port
  to_port           = local.nfs_port
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.eks-shared.outputs.cluster_security_group_id
  security_group_id = aws_security_group.access.id
  description = "NFS communication from EKS DevOps"
}



resource "aws_instance" "server" {
  count                       = var.Instances
  ami                         = data.aws_ami.linux_ami.id
  instance_type               = var.InstanceType
  subnet_id                   = element(data.terraform_remote_state.networking.outputs.private_2_subnet-id, 0)
  vpc_security_group_ids      = [aws_security_group.access.id]
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.nfs_profile.name
  key_name                    = module.aws_key_pair.key_name
  tags = {
    Name         = "${var.Environment}-nfs_${var.linux_distro}_${var.Instances}-${random_string.random.result}-${count.index}"
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

resource "aws_ebs_volume" "ebs" {
  count             = var.Instances
  availability_zone = var.AvailabilityZoneEBS
  size              = var.DiskSizeDataEBS
  type              = "gp2"
  tags = {
    Name = "NFS Dev"
  }
}

resource "aws_volume_attachment" "ebs" {
  count   = var.Instances
  device_name = "/dev/sdb"
  volume_id   = element(aws_ebs_volume.ebs.*.id, count.index)
  instance_id = element(aws_instance.server.*.id, count.index)
}

resource "aws_route53_record" "private_dns" {
  count   = var.Instances
  zone_id = data.terraform_remote_state.networking-shared.outputs.internal_service_domain_id[0]
  name    = "${var.Environment}-nfs-${count.index}.${data.terraform_remote_state.networking-shared.outputs.internal_service_domain}"
  type    = "A"
  ttl     = "60"
  records = [element(aws_instance.server.*.private_ip, count.index)]
}