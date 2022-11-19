terraform {
  required_version = ">= 1.0"
  backend "s3" {
    profile = "atos-integracam-tf-desarrollo-ireland" // Profile con permisos para trabajar sobre el S3 y dynamodb.
    ### Ajustar el valor del bucket al valor desplegado por el modulo Remotetfstate
    bucket         = "s3-devsysops-841131224287-eu-west-1-jjci" // Este es el bucket S3 generado para almacenar el estado de la infarestructura
    key            = "terraform/dev"                         // Se acuerda que el formato sera, terraform/environment de trabajo en este caso dev
    region         = "eu-west-1"                                // Region donde reside los recursos de S3 y DynamoDB para administrar y gestionar el estado de la infraestructura
    encrypt        = true
    dynamodb_table = "tf-up-and-running-locks-eu-west-1-jjci" // Nombre de la tabla que almacena el estado de terraform.
  }
}