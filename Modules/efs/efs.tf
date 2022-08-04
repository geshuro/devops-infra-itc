locals {
    name                               = "efs-${var.vpcName}-${random_string.random.result}"
    efs_security_group_id              = join("", aws_security_group.efs_arqref.*.id)
}

resource "random_string" "random" {
  length    = 3
  min_lower = 3
  special   = false
}

resource "aws_efs_file_system" "efs_arqref" {
  creation_token = local.name

  tags = merge(
    {
      "Name" = local.name
    },
    var.tags
  )
}

resource "aws_efs_mount_target" "efs_arqref" {
  count          = length(var.subnet_ids) > 0 ? length(var.subnet_ids) : 0
  file_system_id = aws_efs_file_system.efs_arqref.id
  subnet_id      = var.subnet_ids[count.index]
  security_groups = [local.efs_security_group_id]

}
