##### Searching  DB Secrets #######################

data "aws_secretsmanager_secret" "db_secret" {
  count = var.secret_name == "" ? 0 : 1
  name = var.secret_name
}

data "aws_secretsmanager_secret_version" "db_secret_sec" {
  count = var.secret_name == "" ? 0 : 1
  secret_id = "${data.aws_secretsmanager_secret.db_secret.*.id}"
}

resource "aws_secretsmanager_secret" "secret" {
  count = var.secret_name == "" ? 1: 0
  name_prefix = "secret_${local.name}"
  tags = merge(var.tags, {
    Name = "secret-${local.name}"
  })
}

resource "aws_secretsmanager_secret_version" "secret" {
  count = var.secret_name == "" ? 1: 0  
  secret_id = join("",aws_secretsmanager_secret.secret.*.id)
  secret_string = jsonencode(var.secret_values)
}