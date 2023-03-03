terraform {
  required_version = "~> 0.12"
  backend "s3" {
    profile = "atos-integracam" // Profile acoradado con el equipo con permisos para trabajar sobre el S3 y dynamodb.
    ### Ajustar el valor del bucket al valor desplegado por el modulo Remotetfstate
    bucket         = "s3-devsysops-711992207767-us-east-1-mbyb" // Este es el bucket S3 generado para almacenar el estado de la infarestructura
    key            = "terraform/shared"                         // Se acuerda que el formato sera, terraform/environment de trabajo en este caso dev
    region         = "us-east-1"                                // Region donde reside los recursos de S3 y DynamoDB para administrar y gestionar el estado de la infraestructura
    encrypt        = true
    dynamodb_table = "tf-up-and-running-locks-us-east-1-mbyb" // Nombre de la tabla que almacena el estado de terraform.
  }
}
