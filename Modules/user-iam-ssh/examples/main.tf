provider "aws" {
  profile = local.profile
  region = local.region
}

module "user-1-ssh" {
  source = "../"
  username = "user1-ssh" 
  ssh_public_key_path = var.ssh_public_key_path
  generate_ssh_key = var.generate_ssh_key
  stage = var.stage
  ProjectId = var.ProjectId
  CostCenter = var.CostCenter
  ServiceId = var.ServiceId
  Environment = var.Environment
  groups = var.groups
}

module "user-2-ssh" {
  source = "../"
  username = "user2-ssh" 
  ssh_public_key_path = var.ssh_public_key_path
  generate_ssh_key = var.generate_ssh_key
  stage = var.stage
  ProjectId = var.ProjectId
  CostCenter = var.CostCenter
  ServiceId = var.ServiceId
  Environment = var.Environment
  groups = var.groups
}

module "user-3-ssh" {
  source = "../"
  username = "user3-ssh" 
  ssh_public_key_path = var.ssh_public_key_path
  generate_ssh_key = var.generate_ssh_key
  stage = var.stage
  ProjectId = var.ProjectId
  CostCenter = var.CostCenter
  ServiceId = var.ServiceId
  Environment = var.Environment
  groups = var.groups
}

# module "user-4-ssh" {
#   source = "../"
#   username = "user4-ssh" 
#   ssh_public_key_path = var.ssh_public_key_path
#   generate_ssh_key = var.generate_ssh_key
#   stage = var.stage
#   ProjectId = var.ProjectId
#   CostCenter = var.CostCenter
#   ServiceId = var.ServiceId
#   Environment = var.Environment
#   groups = var.groups
# }