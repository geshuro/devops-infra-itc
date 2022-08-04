module "user-1-ssh" {
  source = "../../../Modules/user-iam-ssh"
  username = "imendoza"
  ssh_public_key_path = var.ssh_public_key_path
  generate_ssh_key = var.generate_ssh_key
  stage = var.stage
  ProjectId = var.ProjectId
  CostCenter = var.CostCenter
  ServiceId = var.ServiceId
  Environment = var.Environment
  groups = var.groups
}