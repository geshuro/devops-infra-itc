locals {
  region  = "eu-west-1" //Region donde se desplegaran la infraestructura
  profile = "atos-integracam-tf-desarrollo-ireland" //El perfil cuenta con los permisos para desplegar la infraestructura
  # Los tags que se asociaran en los recursos que se van a crear.
  common_tags = {
    CostCenter  = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN" // "identificador-unico-sin-espacios"
    CostCenterId = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN"
    EntityName  = "ATOS" //"Nombre de la Entidad a la que se suscribe el recurso"
    EntityId    = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN" //"id-de-la-entidad-sin-espacios"
    ProjectName = "integracam" //"Nombre del proyecto"
    ProjectId   = "ESTE-VALOR-NO-ESTA-IDENTIFICADO-AUN" //"id-del-proyecto-sin-espacios"
    Environment = "all" //"all"
  }
}