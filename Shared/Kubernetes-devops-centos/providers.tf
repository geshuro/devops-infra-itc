provider "aws" {
  #version = "~> 2.58"
  region  = local.region
  profile = local.profile
}
provider "local" {
  version = "2.2.3"
}
provider "random" {
  version = "3.3.2"
}