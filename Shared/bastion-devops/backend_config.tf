terraform {
  required_version = ">= 1.0"
  backend "s3" {
    profile = "atos-integracam-tf-desarrollo" // Profile acoradado con el equipo con permisos para trabajar sobre el S3 y dynamodb.
    ### Ajustar el valor del bucket al valor desplegado por el modulo Remotetfstate
    bucket         = "s3-devsysops-841131224287-us-east-1-bvvy" // Este es el bucket S3 generado para almacenar el estado de la infarestructura
    key            = "terraform/dev"                            // Se acuerda que el formato sera, terraform/environment de trabajo en este caso dev
    region         = "us-east-1"                                // Region donde reside los recursos de S3 y DynamoDB para administrar y gestionar el estado de la infraestructura
    encrypt        = true
    dynamodb_table = "tf-up-and-running-locks-us-east-1-bvvy" // Nombre de la tabla que almacena el estado de terraform.
  }
}