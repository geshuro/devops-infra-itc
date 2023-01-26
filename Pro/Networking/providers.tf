provider "aws" {
  version = "~> 3.63"
  region  = local.region
  profile = local.profile
}
provider "local" {
  version = "~> 2.1"
}
provider "random" {
  version = "~> 3.1"
}