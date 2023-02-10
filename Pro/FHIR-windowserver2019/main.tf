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

data "terraform_remote_state" "kubernetes-pro" {
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

data "terraform_remote_state" "loadbalancer-shared" {
  backend = "s3"
  config = {
    profile        = var.BackendProfile
    bucket         = var.BackendS3
    key            = "terraform/shared"
    region         = var.BackendRegion
    encrypt        = true
    dynamodb_table = var.BackendDynamoDB // Nombre de la tabla que almacena el estado de terraform.
  }
  workspace = "loadbalancer"
}

# Get latest Windows Server 2019 AMI
data "aws_ami" "windows-2019" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }
}


resource "random_string" "random" {
  length    = 4
  min_lower = 4
  special   = false
}

# Create EC2 Instance
resource "aws_instance" "fhir" {
  count                       = var.Instances
  ami                         = data.aws_ami.windows-2019.id
  instance_type               = var.InstanceType
  subnet_id                   = element(data.terraform_remote_state.networking.outputs.private_2_subnet-id, 0)
  vpc_security_group_ids      = [aws_security_group.fhir_access.id]
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.fhir_profile.name
  source_dest_check           = false
  key_name                    = module.aws_key_pair.key_name
  get_password_data           = true
  user_data                   = templatefile("${path.module}/cloud-init.tpl", {windows_instance_name  = "${var.windows_instance_name}"})
  #user_data                   = data.template_file.windows-userdata.rendered
  
  tags = {
    Name         = "${var.Environment}-windows-fhir_${var.Instances}-${random_string.random.result}-${count.index}"
    Owner        = var.Owner
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
    Auto-Start   = var.AutoStart
    Auto-Stop    = var.AutoStop
  }

  # root disk
  root_block_device {
    volume_size           = var.windows_root_volume_size
    volume_type           = var.windows_root_volume_type
    delete_on_termination = true
    encrypted             = true
  }

  # extra disk
  /*ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = var.windows_data_volume_size
    volume_type           = var.windows_data_volume_type
    encrypted             = true
    delete_on_termination = true
  }*/
  

}

resource "aws_route53_record" "fhir_dns" {
  count   = var.Instances
  zone_id = data.terraform_remote_state.networking-shared.outputs.internal_service_domain_id[0]
  name    = "${var.Environment}-fhir-${count.index}.${data.terraform_remote_state.networking-shared.outputs.internal_service_domain}"
  type    = "A"
  ttl     = "60"
  records = [element(aws_instance.fhir.*.private_ip, count.index)]
}

resource "aws_iam_role" "fhir_role" {
  name               = "fhir-role-${random_string.random.result}"
  assume_role_policy = file("role_policy/assume-role-policy.json")
  tags = {
    Name         = "fhir-role-${random_string.random.result}"
    Owner        = var.Owner
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
  }
}

resource "aws_iam_instance_profile" "fhir_profile" {
  name  = "fhir-profile-${random_string.random.result}"
  role = aws_iam_role.fhir_role.name
}

resource "aws_iam_policy" "fhir_policy" {
  name   = "fhir-policy-${random_string.random.result}"
  policy = file("role_policy/policy-s3-bucket.json")
}

resource "aws_iam_policy_attachment" "fhir_attachment" {
  name       = "fhir-attachment-${random_string.random.result}"
  roles      = [aws_iam_role.fhir_role.name]
  policy_arn = aws_iam_policy.fhir_policy.arn
}


# Creacion de Keypair para el servicio
module "aws_key_pair" {
  source              = "../../Modules/keypair"
  namespace           = "kp"
  stage               = var.Environment
  name                = "kp-${var.Environment}-windows-fhir-${random_string.random.result}"
  attributes          = [random_string.random.result]
  delimiter           = "-"
  ssh_public_key_path = "./secret"
  generate_ssh_key    = true
}

# Subida de datos a SSM de los Keypair
module "ssm-key-pair" {
   source      = "../../Modules/ssm-parameter"
   name        = "/${var.Environment}/keypair/windows-fhir-${random_string.random.result}/${module.aws_key_pair.key_name}/ssh-public"
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

resource "aws_security_group" "fhir_access" {
  name        = "${var.Environment}-fhir-${random_string.random.result}"
  description = "Allow traffic for custom server fhir"
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "${var.Environment}-fhir-${random_string.random.result}"
    Owner        = var.Owner
    Environment  = var.Environment
    CostCenter   = var.CostCenter
    CostCenterId = var.CostCenterId
    ServiceId    = var.ServiceId
    ProjectId    = var.ProjectId
  }
}

resource "aws_security_group_rule" "bastion_to_fhir_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.fhir_access.id
  description = "fhir http communication from Bastion"
}

resource "aws_security_group_rule" "bastion_to_fhir_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.fhir_access.id
  description = "fhir https communication from Bastion"
}

resource "aws_security_group_rule" "bastion_to_fhir_1" {
  type              = "ingress"
  from_port         = 1433
  to_port           = 1433
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.fhir_access.id
  description = "fhir TCP/1433 communication from Bastion"
}

resource "aws_security_group_rule" "bastion_to_fhir_2" {
  type              = "ingress"
  from_port         = 5090
  to_port           = 5090
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.fhir_access.id
  description = "fhir TCP/5090 communication from Bastion"
}

resource "aws_security_group_rule" "bastion_to_fhir_3" {
  type              = "ingress"
  from_port         = 5300
  to_port           = 5300
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.fhir_access.id
  description = "fhir TCP/5300 communication from Bastion"
}

resource "aws_security_group_rule" "bastion_to_fhir_4" {
  type              = "ingress"
  from_port         = 5310
  to_port           = 5310
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.fhir_access.id
  description = "fhir TCP/5310 communication from Bastion"
}

resource "aws_security_group_rule" "bastion_to_fhir_5" {
  type              = "ingress"
  from_port         = 5320
  to_port           = 5320
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.fhir_access.id
  description = "fhir TCP/5320 communication from Bastion"
}

resource "aws_security_group_rule" "bastion_to_fhir_6" {
  type              = "ingress"
  from_port         = 5330
  to_port           = 5330
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.fhir_access.id
  description = "fhir TCP/5330 communication from Bastion"
}

resource "aws_security_group_rule" "bastion_to_fhir_7" {
  type              = "ingress"
  from_port         = 5331
  to_port           = 5331
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.fhir_access.id
  description = "fhir TCP/5331 communication from Bastion"
}

resource "aws_security_group_rule" "bastion_to_fhir_8" {
  type              = "ingress"
  from_port         = 5340
  to_port           = 5340
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.fhir_access.id
  description = "fhir TCP/5340 communication from Bastion"
}

resource "aws_security_group_rule" "bastion_to_fhir_9" {
  type              = "ingress"
  from_port         = 9990
  to_port           = 9990
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.fhir_access.id
  description = "fhir TCP/9990 communication from Bastion"
}

resource "aws_security_group_rule" "bastion_to_fhir_10" {
  type              = "ingress"
  from_port         = 9091
  to_port           = 9091
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.fhir_access.id
  description = "fhir TCP/9091 communication from Bastion"
}

resource "aws_security_group_rule" "bastion_to_fhir_11" {
  type              = "ingress"
  from_port         = 1434
  to_port           = 1434
  protocol          = local.protocol_udp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.fhir_access.id
  description = "fhir UDP/1434 communication from Bastion"
}

resource "aws_security_group_rule" "bastion_to_fhir_12" {
  type              = "ingress"
  from_port         = 5300
  to_port           = 5300
  protocol          = local.protocol_udp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.fhir_access.id
  description = "fhir UDP/5300 communication from Bastion"
}

resource "aws_security_group_rule" "bastion_to_fhir_13" {
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion.outputs.bastion_sg_id
  security_group_id = aws_security_group.fhir_access.id
  description = "fhir TCP/3389 communication from Bastion"
}

resource "aws_security_group_rule" "fhir_all_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.fhir_access.id
  description = "ALL port communication from fhir"
}

resource "aws_security_group_rule" "bastion-devops_to_fhir_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion-devops.outputs.security_group_id
  security_group_id = aws_security_group.fhir_access.id
  description = "fhir http communication from Bastion DevOps"
}

resource "aws_security_group_rule" "bastion-devops_to_fhir_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.bastion-devops.outputs.security_group_id
  security_group_id = aws_security_group.fhir_access.id
  description = "fhir https communication from Bastion DevOps"
}

resource "aws_security_group_rule" "kubernetes-pro_to_fhir_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.kubernetes-pro.outputs.server_security_group_id[0]
  security_group_id = aws_security_group.fhir_access.id
  description = "fhir http communication from Kubernetes Pro"
}

resource "aws_security_group_rule" "kubernetes-pro_to_fhir_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = local.protocol_tcp
  source_security_group_id  = data.terraform_remote_state.kubernetes-pro.outputs.server_security_group_id[0]
  security_group_id = aws_security_group.fhir_access.id
  description = "fhir https communication from Kubernetes Pro"
}

resource "aws_security_group_rule" "loadbalancer_to_fhir_nodeports" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  source_security_group_id  = element(data.terraform_remote_state.loadbalancer-shared.outputs.server_security_group_id, 0)
  security_group_id = aws_security_group.fhir_access.id
  description = "ALL Port FHIR from Loadbalancer"
}