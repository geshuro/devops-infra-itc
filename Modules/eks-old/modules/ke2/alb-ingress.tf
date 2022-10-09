locals {
  install_alb_ingress = var.install_alb_ingress

  alb_ingress_name      = "alb-ingress"
  alb_ingress_namespace = "kube-system"

  alb_ingress_iam_resource_name = "k8s-${local.alb_ingress_name}-ctrl-${var.project}-${var.environment}-${var.aws_region}"
  aws_account_id = var.aws_account_id != "" ? var.aws_account_id : data.aws_caller_identity.current.account_id
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.alb_ingress_namespace}:${local.alb_ingress_name}"]
  create_role = var.install_alb_ingress && local.iam_oidc_mode_enabled
  role_policy_arns = [join("", aws_iam_policy.aws_alb_ingress.*.arn)]
  oidc_subjects_with_wildcards = []
  role_path = "/"
  max_session_duration= 3600
  role_permissions_boundary_arn = ""

}

resource "random_string" "random" {
  length    = 4
  min_lower = 4
  special   = false
}
/*deprecado
##  Helm install ######
data "helm_repository" "incubator" {
  name = "incubator"
  url  = "http://storage.googleapis.com/kubernetes-charts-incubator"
}*/

resource "helm_release" "aws_alb_ingress" {
  count = local.install_alb_ingress ? 1 : 0
  repository = "https://aws.github.io/eks-charts"
  keyring   = ""
  name      = local.alb_ingress_name
  namespace = local.alb_ingress_namespace
  chart     = "aws-load-balancer-controller"

  values = [
    join("", data.template_file.aws_alb_ingress.*.rendered),
  ]

  set {
    name  = "nameOverride"
    value = local.alb_ingress_name
  }
  
  /*set {
    name  = "podSecurityContext.runAsUser"
    value = 1000
  }*/
  
  
  # depends_on = [kubernetes_deployment.tiller_deploy]
}

data "template_file" "aws_alb_ingress" {
  count = local.install_alb_ingress ? 1 : 0

  template = file("${local.files_path}/templates/alb-ingress/values.yaml.tpl")

  vars = {
    aws_region   = var.aws_region
    cluster_name = var.cluster_name
    vpc_id       = var.vpc_id

    auto_discover_aws_region = false
    auto_discover_vpc        = false

    container_image_tag = var.alb_ingress_container_image_tag

    service_account_name                = local.alb_ingress_name
    service_account_iam_role_annotation = local.iam_oidc_mode_enabled ? "${local.eks_iam_service_account_annotation}: ${aws_iam_role.arqref[0].arn}" : ""
    # service_account_iam_role_annotation = "eks.amazonaws.com/role-arn: aws:iam::175145454340:role/k8s-alb-ingress-ctrl-arqref-dev-eu-west-1" 
    ## kube2iam_pod_annotation = local.install_kube2iam_to_assign_roles_to_pods ? "iam.amazonaws.com/role: '${join("", aws_iam_role.autoscaler_kube2iam.*.arn)}'" : ""

    resource_limits_cpu   = var.alb_ingress_resource_limits_cpu
    resource_limits_mem   = var.alb_ingress_resource_limits_mem
    resource_requests_cpu = var.alb_ingress_resource_requests_cpu
    resource_requests_mem = var.alb_ingress_resource_requests_mem
  }
}

###  Iam permissions for ALB Ingress ################

resource "aws_iam_policy" "aws_alb_ingress" {
  count = var.install_alb_ingress ? 1 : 0

  name   = "${local.alb_ingress_iam_resource_name}-${random_string.random.result}"
  policy = join("", data.aws_iam_policy_document.aws_alb_ingress_role_policy.*.json)
}

data "aws_iam_policy_document" "aws_alb_ingress_role_policy" {
  count = var.install_alb_ingress ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "acm:GetCertificate",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVpcs",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:RevokeSecurityGroupIngress",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "elasticloadbalancing:AddListenerCertificates",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:DescribeListenerCertificates",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyRule",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RemoveListenerCertificates",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
      "elasticloadbalancing:SetWebACL",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "iam:CreateServiceLinkedRole",
      "iam:GetServerCertificate",
      "iam:ListServerCertificates",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "waf-regional:GetWebACLForResource",
      "waf-regional:GetWebACL",
      "waf-regional:AssociateWebACL",
      "waf-regional:DisassociateWebACL",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "tag:GetResources",
      "tag:TagResources",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "waf:GetWebACL",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "cognito-idp:DescribeUserPool",
      "cognito-idp:DescribeUserPoolClient",
      "cognito-idp:ListUserPoolClients",
      "cognito-idp:ListUserPools",
    ]

    resources = ["*"]
  }
}

##########
# iam-oidc role
##########
# since the helm chart for the external-dns controller supports service account annotations we do not need to
# use the module that creates the role an annotates the account (since helm will annotate it for us)
# module "alb_ingress_iam_role" {
#   source = "git::https://github.com/miguelaferreira/terraform-aws-iam.git//modules/iam-assumable-role-with-iodc?ref=iam-assumable-role-with-oidc"

#   create_role = var.install_alb_ingress && local.iam_oidc_mode_enabled

#   provider_url = var.oidc_provider_url

#   role_name        = local.alb_ingress_iam_resource_name
#   role_policy_arns = [join("", aws_iam_policy.aws_alb_ingress.*.arn)]

#   oidc_fully_qualified_subjects = ["system:serviceaccount:${local.alb_ingress_namespace}:${local.alb_ingress_name}"]

#   tags = var.tags
# }

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role_with_oidc" {
  count = local.create_role ? 1 : 0

  statement {
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"

      identifiers = [
        "arn:aws:iam::${local.aws_account_id}:oidc-provider/${var.oidc_provider_url}"
      ]
    }

    dynamic "condition" {
      for_each = local.oidc_fully_qualified_subjects
      content {
        test     = "StringEquals"
        variable = "${var.oidc_provider_url}:sub"
        values   = [condition.value]
      }
    }

    dynamic "condition" {
      for_each = local.oidc_subjects_with_wildcards
      content {
        test     = "StringLike"
        variable = "${var.oidc_provider_url}:sub"
        values   = [condition.value]
      }
    }
  }
}

resource "aws_iam_role" "arqref" {
  count = local.create_role ? 1 : 0

  name                 = "${local.alb_ingress_iam_resource_name}-${random_string.random.result}"
  path                 = local.role_path
  max_session_duration = local.max_session_duration

  permissions_boundary = local.role_permissions_boundary_arn

  assume_role_policy = join("", data.aws_iam_policy_document.assume_role_with_oidc.*.json)

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "custom" {
  count = local.create_role && length(local.role_policy_arns) > 0 ? length(local.role_policy_arns) : 0

  role       = join("", aws_iam_role.arqref.*.name)
  policy_arn = local.role_policy_arns[count.index]
}
