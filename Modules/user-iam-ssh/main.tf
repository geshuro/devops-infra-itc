# Creacion de usuario para asignarles acceso a bastion por ssh y openvpn

# Create usuario
resource "aws_iam_user" "user" {
  name = var.username
}

# Asignarle a grupos

resource "aws_iam_user_group_membership" "user" {
  user = aws_iam_user.user.name
  #groups = [aws_iam_group.ssh.name, aws_iam_group.ssh-admin.name]
  groups = var.groups
}

#data. group-ssh

# Crear key_pair
module "aws_key_pair_user" {
  source              = "../keypair"
  namespace           = "ssh"
  stage               = "user"
  name                = aws_iam_user.user.name
  ssh_public_key_path = var.ssh_public_key_path
  generate_ssh_key    = var.generate_ssh_key
}

module "ssm-key-pair-user-public" {
   source      = "../ssm-parameter"
   name        = "/users/ssh/${aws_iam_user.user.name}/${module.aws_key_pair_user.key_name}/ssh-public"
   description = "Datos del ssh-public para el usuario ${var.username}"
   type        = "SecureString"
   value       = module.aws_key_pair_user.public_key

   tags = {
        "Terraform"           = "true"
        "Environment"         = var.stage
        "ProjectId"           = var.ProjectId
        "CostCenter"          = var.CostCenter
        "ServiceId"           = var.ServiceId
   }
}

module "ssm-key-pair-user-private" {
   source      = "../ssm-parameter"
   name        = "/users/ssh/${aws_iam_user.user.name}/${module.aws_key_pair_user.key_name}/ssh-private"
   description = "Datos del ssh-private par el usuario ${var.username}"
   type        = "SecureString"
   value       = module.aws_key_pair_user.private_key

   tags = {
        "Terraform"           = "true"
        "Environment"         = var.stage
        "ProjectId"           = var.ProjectId
        "CostCenter"          = var.CostCenter
        "ServiceId"           = var.ServiceId
   }
}

# Subir 
resource "aws_iam_user_ssh_key" "user" {
  username   = aws_iam_user.user.name
  encoding   = "SSH"
  public_key = module.aws_key_pair_user.public_key
}