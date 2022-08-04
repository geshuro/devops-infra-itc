variable "tags" {
  description = "A map of tags to add networking resources"
  type        = map
  default = {
    Environment = "pro"
    CostCenter  = ""
    ServiceId   = ""
    ProjectId   = ""
  }
}