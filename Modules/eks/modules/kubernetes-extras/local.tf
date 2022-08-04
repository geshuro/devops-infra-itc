locals {
  location_prefix = var.files_path != "" ? var.files_path : "${path.module}/"
  files_path      = "${local.location_prefix}files"
  templates_path  = "${local.location_prefix}files/templates"
  cluster_name    = var.cluster_name != "" ? var.cluster_name : "${title(var.project)}${title(var.environment)}"

  iam_oidc_mode_enabled                    =  var.pod_iam_policy_mode == "iam-oidc"
  # install_kube2iam_to_assign_roles_to_pods = var.pod_iam_policy_mode == "kube2iam"

  eks_iam_service_account_annotation = "eks.amazonaws.com/role-arn"

  # alb_ingress_kube2iam_annotation = local.install_kube2iam_to_assign_roles_to_pods ? "podAnnotations:\n  iam.amazonaws.com/role: '${join("", aws_iam_role.aws_alb_ingress_kube2iam.*.arn)}'" : ""

  #alb_ingress_values = [
  #  var.istio_alb_ingress_helm_values != "" ? format("%s\n%s", var.istio_alb_ingress_helm_values, local.alb_ingress_kube2iam_annotation) : local.alb_ingress_kube2iam_annotation,                
  # ]

  alb_auth_idp_cognito = "{\"UserPoolArn\":\"${var.istio_alb_ingress_cognito_user_pool_arn}\", \"UserPoolClientId\":\"${var.istio_alb_ingress_cognito_user_pool_default_client_id}\", \"UserPoolDomain\":\"${var.istio_alb_ingress_cognito_user_pool_custom_domain_name}\"}"

  alb_auth_cognito = [
    "alb.ingress.kubernetes.io/auth-type: cognito",
    "    alb.ingress.kubernetes.io/auth-idp-cognito: '${local.alb_auth_idp_cognito}'",
    "    alb.ingress.kubernetes.io/auth-on-unauthenticated-request: authenticate",
    "    alb.ingress.kubernetes.io/auth-scope: openid",
    "    alb.ingress.kubernetes.io/auth-session-timeout: '86400'",
  ]

}