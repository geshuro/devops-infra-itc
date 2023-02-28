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

data "terraform_remote_state" "kubernetes" {
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

resource "aws_iam_role" "postgresql_role" {
  name               = "postgresql-role-${random_string.random.result}"
  assume_role_policy = file("role_policy/assume-role-policy.json")
  tags = {
    Name         = "postgresql-role-${random_string.random.result}"
    Owner        = var.Owner
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
  }
}

resource "aws_iam_policy" "postgresql_policy" {
  name   = "postgresql-policy-${random_string.random.result}"
  policy = file("role_policy/policy-s3-bucket.json")
}

resource "aws_iam_policy_attachment" "postgresql_attachment" {
  name       = "postgresql-attachment-${random_string.random.result}"
  roles      = [aws_iam_role.postgresql_role.name]
  policy_arn = aws_iam_policy.postgresql_policy.arn
}

resource "aws_iam_instance_profile" "postgresql_profile" {
  name  = "postgresql-profile-${random_string.random.result}"
  role = aws_iam_role.postgresql_role.name
}

# Creacion de Keypair para el servicio
module "aws_key_pair" {
  source              = "../../Modules/keypair"
  namespace           = "kp"
  stage               = var.Environment
  name                = "kp-${var.Environment}-postgresql-${random_string.random.result}"
  attributes          = [random_string.random.result]
  delimiter           = "-"
  ssh_public_key_path = "./secret"
  generate_ssh_key    = true
}

# Subida de datos a SSM de los Keypair
module "ssm-key-pair" {
   source      = "../../Modules/ssm-parameter"
   name        = "/${var.Environment}/keypair/postgresql-${random_string.random.result}/${module.aws_key_pair.key_name}/ssh-public"
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

resource "aws_security_group" "postgresql_access" {
  name        = "${var.Environment}-postgresql-${random_string.random.result}"
  description = "Allow traffic for custom cluster postgresql"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "${var.Environment}-postgresql-${random_string.random.result}"
    Owner        = var.Owner
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
  }
}

resource "aws_security_group_rule" "bastion-devops_to_postgresql_ssh" {
  type              = "ingress"
  from_port         = local.ssh_port
  to_port           = local.ssh_port
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion-devops.outputs.security_group_id
  security_group_id = aws_security_group.postgresql_access.id
  description = "postgresql ssh communication from Bastion DevOps"
}

resource "aws_security_group_rule" "bastion_to_postgresql_ssh" {
  type              = "ingress"
  from_port         = local.ssh_port
  to_port           = local.ssh_port
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.postgresql_access.id
  description = "postgresql ssh communication from Bastion DevOps"
}

resource "aws_security_group_rule" "bastion_to_postgresql_pgbouncer" {
  type              = "ingress"
  from_port         = 6432
  to_port           = 6432
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.postgresql_access.id
  description = "postgresql pgbouncer communication from Bastion Shared"
}

resource "aws_security_group_rule" "bastion_devops_to_postgresql_pgbouncer" {
  type              = "ingress"
  from_port         = 6432
  to_port           = 6432
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion-devops.outputs.security_group_id
  security_group_id = aws_security_group.postgresql_access.id
  description = "postgresql pgbouncer communication from Bastion DevOps"
}

resource "aws_security_group_rule" "bastion_to_postgresql_master" {
  type              = "ingress"
  from_port         = local.postgresql_read_write_port
  to_port           = local.postgresql_read_write_port
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.postgresql_access.id
  description = "postgresql master communication from Bastion DevOps"
}

resource "aws_security_group_rule" "bastion_to_postgresql_replica" {
  type              = "ingress"
  from_port         = local.postgresql_read_port
  to_port           = local.postgresql_read_port
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.postgresql_access.id
  description = "postgresql replicas communication from Bastion DevOps"
}

resource "aws_security_group_rule" "postgresql_master" {
  type              = "ingress"
  from_port         = local.postgresql_read_write_port
  to_port           = local.postgresql_read_write_port
  protocol          = local.protocol_tcp
  self              = true
  security_group_id = aws_security_group.postgresql_access.id
  description = "port 5000 (read / write) master"
}

resource "aws_security_group_rule" "postgresql_replica" {
  type              = "ingress"
  from_port         = local.postgresql_read_port
  to_port           = local.postgresql_read_port
  protocol          = local.protocol_tcp
  self              = true
  security_group_id = aws_security_group.postgresql_access.id
  description = "port 5001 (read only) all replicas"
}

resource "aws_security_group_rule" "postgresql_all_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.postgresql_access.id
  description = "ALL port communication from postgresql"
}

resource "aws_security_group_rule" "kubernetes_to_postgresql_pgbouncer" {
  type              = "ingress"
  from_port         = 6432
  to_port           = 6432
  protocol          = local.protocol_tcp
  source_security_group_id  = element(data.terraform_remote_state.kubernetes.outputs.server_security_group_id, 0)
  security_group_id = aws_security_group.postgresql_access.id
  description = "postgresql pgbouncer communication from Kubernetes pro"
}

resource "aws_instance" "postgresql_server" {
  count                       = var.Instances
  ami                         = data.aws_ami.linux_ami.id
  instance_type               = var.InstanceType
  subnet_id                   = element(data.terraform_remote_state.networking.outputs.private_2_subnet-id, 0)
  vpc_security_group_ids      = [aws_security_group.postgresql_access.id]
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.postgresql_profile.name
  key_name                    = module.aws_key_pair.key_name
  tags = {
    Name         = "${var.Environment}-postgresql_${var.linux_distro}_${var.Instances}-${random_string.random.result}-${count.index}"
    Owner        = var.Owner
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
    Auto-Start   = var.AutoStart
    Auto-Stop    = var.AutoStop
  }
  /*probar despues para automatizar ssh desde ansible
  provisioner "remote-exec" {
    inline = [
        "sudo adduser --disabled-password --gecos '' devopsansible",
        "sudo mkdir -p /home/devopsansible/.ssh",
        "sudo touch /home/devopsansible/.ssh/authorized_keys",
        "sudo echo '${var.MY_USER_PUBLIC_KEY}' > authorized_keys",
        "sudo mv authorized_keys /home/devopsansible/.ssh",
        "sudo chown -R devopsansible:devopsansible /home/devopsansible/.ssh",
        "sudo chmod 700 /home/devopsansible/.ssh",
        "sudo chmod 600 /home/devopsansible/.ssh/authorized_keys",
        "sudo usermod -aG sudo devopsansible"
   ]

    connection {
     user     = "ubuntu"
    }

  }*/
}

resource "aws_route53_record" "postgresql_private_dns" {
  count   = var.Instances
  zone_id = data.terraform_remote_state.networking-shared.outputs.internal_service_domain_id[0]
  name    = "${var.Environment}-postgresql.${data.terraform_remote_state.networking-shared.outputs.internal_service_domain}"
  type    = "A"
  ttl     = "60"
  records = [element(aws_instance.postgresql_server.*.private_ip, count.index)]
}