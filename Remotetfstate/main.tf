provider "aws" {
  region  = local.region
  profile = local.profile
}
# terraform state file setup
# create an S3 bucket to store the state file in
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "random_string" "random" {
  length    = 4
  min_lower = 4
  special   = false
}

resource "random_uuid" "test" {}

resource "aws_s3_bucket" "terraform-state-storage-s3" {
  bucket = "s3-devsysops-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}-${random_string.random.result}"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  lifecycle {
    # No se elimina este recurso
    prevent_destroy = true
    #TODO: IgnoreChanges
  }

  tags = local.common_tags
}

resource "aws_dynamodb_table" "terraform-locks" {
  name           = "tf-up-and-running-locks-${data.aws_region.current.name}-${random_string.random.result}"
  #deprecado read_capacity  = 2
  #deprecado write_capacity = 2
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  lifecycle {
    ignore_changes  = [read_capacity, write_capacity]
    prevent_destroy = true
  }
  attribute {
    name = "LockID"
    type = "S"
  }
  server_side_encryption {
    enabled = true
  }
}