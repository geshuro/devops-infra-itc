provider "aws" {
  region  = "eu-west-1"
  profile = "indra-arqref"
}

terraform {
  required_version = "~> 0.12"
  backend "s3" {
    profile = "indra-arqref"
    ### Ajustar el valor del bucket al valor desplegado por el modulo Remotetfstate
    bucket         = "s3-devsysops-175145454340-eu-west-1-jwyy"
    key            = "terraform/dev"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "tf-up-and-running-locks-eu-west-1-jwyy"
  }
}
