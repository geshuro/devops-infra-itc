module "label1" {
  source      = "../../"
  namespace   = "Global"
  environment = "dev"
  stage       = "develop"
  name        = "srojo caminos"
  attributes  = ["sg", "rds", "eredis", "efs"]
  delimiter   = "-"

  label_order = ["name", "environment", "stage", "attributes"]

  tags = {
    "Environment"        = "dev"
    "ProjectId" = "pid-454445-45-45"
  }
}

output "label1" {
  value = {
    id         = module.label1.id
    name       = module.label1.name
    namespace  = module.label1.namespace
    stage      = module.label1.stage
    attributes = module.label1.attributes
    delimiter  = module.label1.delimiter
  }
}

output "label1_tags" {
  value = module.label1.tags
}

output "label1_context" {
  value = module.label1.context
}



