/**
* ## WAF Module Example
*
* This module creates a Regional Web ACL with the defult ruleset blocking SQL injection.
* If enabled, associates the Web ACL to an existing API Gateway stage.
*/

module "waf" {
  source = "../"

  web_acl_name = "example_WebACL"

  associate_api_gateway  = false
  rest_api_gw_id         = ""
  rest_api_gw_stage_name = ""

  AWS_REGION  = "eu-west-1"
  AWS_PROFILE = "atos-arqref"
  tags = {
    company     = "Atos"
    project     = "Arquitecturas de Referencia - APIGW - Servicios"
    terraform   = "true"
    Environment = "pro"
    CostCenter  = ""
    ServiceId   = ""
    ProjectId   = ""
  }
}