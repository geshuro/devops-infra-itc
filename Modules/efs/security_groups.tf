resource "aws_security_group" "efs_arqref" {
   
  count = var.create_security_group ? 1 : 0
  name_prefix = "${local.name}-"

  description = "Allows for NFS traffic for ${local.name}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.security_group_ingress
    content {
      from_port   = lookup(ingress.value, "from_port", null)
      protocol    = lookup(ingress.value, "protocol", null)
      to_port     = lookup(ingress.value, "to_port", null)
      self        = lookup(ingress.value, "self", null)
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)
      # security_groups = lookup (ingress.value, "source_security_group_id", null)
    }
  }

  dynamic "egress" {
    for_each = var.security_group_egress
    content {
      from_port   = lookup(egress.value, "from_port", null)
      protocol    = lookup(egress.value, "protocol", null)
      to_port     = lookup(egress.value, "to_port", null)
      self        = lookup(egress.value, "self", null)
      cidr_blocks = lookup(egress.value, "cidr_blocks", null)
    }
  }

  tags = merge(var.tags, {
    Name = "sg-${local.name}"
  })
}