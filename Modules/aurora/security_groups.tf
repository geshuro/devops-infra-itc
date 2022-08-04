########    Security Groups   #######################

resource "aws_security_group" "aurora_arqref" {
  count = var.create_security_group ? 1 : 0

  name_prefix = "${local.name}-"
  vpc_id      = var.vpc_id

  description = var.security_group_description == "" ? "Control traffic to/from RDS Aurora ${local.name}" : var.security_group_description

  tags = merge(var.tags, {
    Name = "sg-${local.name}"
  })
}

##### Ingress Rules ###################################

resource "aws_security_group_rule" "default_ingress" {
  count = var.create_security_group ? length(var.allowed_security_groups) > 0 ? length(var.allowed_security_groups) : 0 : 0
  description = "From allowed SGs"

  type                     = "ingress"
  from_port                = aws_rds_cluster.aurora_arqref.port
  to_port                  = aws_rds_cluster.aurora_arqref.port
  protocol                 = "tcp"
  source_security_group_id = element(var.allowed_security_groups, count.index)
  security_group_id        = local.rds_security_group_id
}

resource "aws_security_group_rule" "self_ingress" {
  count = var.create_security_group ? 1 : 0

  description = "From the self SG"

  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  self              = true
  security_group_id = local.rds_security_group_id
}