# #################Security Group #####################################

# resource "aws_security_group" "redis_arqref" {
#   count = var.create_security_group ? 1 : 0

#   name_prefix = "${local.name}-"
#   description = "ElastiCache security group for ${local.name}"
#   vpc_id      = var.vpc_id
#   tags        = merge(var.tags, {Name = "sg-${local.name}"})
#   }

# ############## Rules ##################################################

# resource "aws_security_group_rule" "redis_ingress" {
#   count = var.create_security_group ? length(var.allowed_security_groups) > 0 ? length(var.allowed_security_groups) : 0 : 0

#   description              = "From allowed SGs to port Redis"
#   type                     = "ingress"
#   from_port                = var.redis_port
#   to_port                  = var.redis_port
#   protocol                 = "tcp"
#   source_security_group_id = element(var.allowed_security_groups, count.index)
#   security_group_id        = local.redis_security_group_id
# }

# resource "aws_security_group_rule" "redis_self_ingress" {
#   count = var.create_security_group ? 1 : 0

#   description = "From the self SG"

#   type              = "ingress"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "tcp"
#   self              = true
#   security_group_id = local.redis_security_group_id
# }
