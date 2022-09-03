####    Data Resources   ###

data "aws_iam_policy_document" "cluster_assume_role_policy" {
  statement {
    sid = "EKSClusterAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "template_file" "kubeconfig" {
  count    = var.create_eks ? 1 : 0
  template = file("${path.module}/templates/kubeconfig.tpl")

  vars = {
    kubeconfig_name           = local.kubeconfig_name
    endpoint                  = aws_eks_cluster.arqref[0].endpoint
    cluster_auth_base64       = aws_eks_cluster.arqref[0].certificate_authority[0].data
    aws_authenticator_command = var.kubeconfig_aws_authenticator_command
    aws_authenticator_command_args = length(var.kubeconfig_aws_authenticator_command_args) > 0 ? "        - ${join(
      "\n        - ",
      var.kubeconfig_aws_authenticator_command_args,
      )}" : "        - ${join(
      "\n        - ",
      formatlist("\"%s\"", ["token", "-i", aws_eks_cluster.arqref[0].name]),
    )}"
    aws_authenticator_additional_args = length(var.kubeconfig_aws_authenticator_additional_args) > 0 ? "        - ${join(
      "\n        - ",
      var.kubeconfig_aws_authenticator_additional_args,
    )}" : ""
    aws_authenticator_env_variables = length(var.kubeconfig_aws_authenticator_env_variables) > 0 ? "      env:\n${join(
      "\n",
      data.template_file.aws_authenticator_env_variables.*.rendered,
    )}" : ""
  }
}

data "template_file" "aws_authenticator_env_variables" {
  count = length(var.kubeconfig_aws_authenticator_env_variables)

  template = <<EOF
        - name: $${key}
          value: $${value}
EOF


  vars = {
    value = values(var.kubeconfig_aws_authenticator_env_variables)[count.index]
    key   = keys(var.kubeconfig_aws_authenticator_env_variables)[count.index]
  }
}


data "aws_iam_role" "custom_cluster_iam_role" {
  count = var.manage_cluster_iam_resources ? 0 : 1
  name  = var.cluster_iam_role_name
}


##### EKS Resources ####

resource "aws_cloudwatch_log_group" "arqref" {
  count             = length(var.cluster_enabled_log_types) > 0 && var.create_eks ? 1 : 0
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.cluster_log_retention_in_days
  kms_key_id        = var.cluster_log_kms_key_id
  tags              = var.tags
}

resource "aws_eks_cluster" "arqref" {
  count                     = var.create_eks ? 1 : 0
  name                      = var.cluster_name
  enabled_cluster_log_types = var.cluster_enabled_log_types
  role_arn                  = local.cluster_iam_role_arn
  version                   = var.cluster_version
  tags                      = var.tags

  vpc_config {
    security_group_ids      = compact([local.cluster_security_group_id])
    subnet_ids              = var.subnets
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  }

  timeouts {
    create = var.cluster_create_timeout
    delete = var.cluster_delete_timeout
  }

  dynamic encryption_config {
    for_each = toset(var.cluster_encryption_config)

    content {
      provider {
        key_arn = encryption_config.value["provider_key_arn"]
      }
      resources = encryption_config.value["resources"]
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy,
    aws_cloudwatch_log_group.arqref
  ]
  provisioner "local-exec" {
    command = "sleep 20" //Waits 10 seconds, prevents apigw_account error
  }
}


resource "aws_security_group_rule" "cluster_private_access" {
  count       = var.create_eks && var.manage_aws_auth && var.cluster_endpoint_private_access && var.cluster_endpoint_public_access == false ? 1 : 0
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = var.cluster_endpoint_private_access_cidrs

  security_group_id = aws_eks_cluster.arqref[0].vpc_config[0].cluster_security_group_id
}


resource "null_resource" "wait_for_cluster" {
  count = var.create_eks && var.manage_aws_auth ? 1 : 0

  depends_on = [
    aws_eks_cluster.arqref[0],
    aws_security_group_rule.cluster_private_access,
  ]

  provisioner "local-exec" {
    command     = var.wait_for_cluster_cmd
    interpreter = var.wait_for_cluster_interpreter
    environment = {
      ENDPOINT = aws_eks_cluster.arqref[0].endpoint
    }
  }
}

resource "aws_security_group" "cluster" {
  count       = var.cluster_create_security_group && var.create_eks ? 1 : 0
  name_prefix = var.cluster_name
  description = "EKS cluster security group."
  vpc_id      = var.vpc_id
  tags = merge(
    var.tags,
    {
      "Name" = "${var.cluster_name}-eks_cluster_sg"
    },
  )
}

resource "aws_security_group_rule" "cluster_egress_internet" {
  count             = var.cluster_create_security_group && var.create_eks ? 1 : 0
  description       = "Allow cluster egress access to the Internet."
  protocol          = "-1"
  security_group_id = local.cluster_security_group_id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "cluster_https_worker_ingress" {
  count                    = var.cluster_create_security_group && var.create_eks ? 1 : 0
  description              = "Allow pods to communicate with the EKS cluster API."
  protocol                 = "tcp"
  security_group_id        = local.cluster_security_group_id
  source_security_group_id = local.worker_security_group_id
  from_port                = 443
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_iam_role" "cluster" {
  count                 = var.manage_cluster_iam_resources && var.create_eks ? 1 : 0
  name_prefix           = var.cluster_name
  assume_role_policy    = data.aws_iam_policy_document.cluster_assume_role_policy.json
  permissions_boundary  = var.permissions_boundary
  path                  = var.iam_path
  force_detach_policies = true
  tags                  = var.tags
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  count      = var.manage_cluster_iam_resources && var.create_eks ? 1 : 0
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSClusterPolicy"
  role       = local.cluster_iam_role_name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSServicePolicy" {
  count      = var.manage_cluster_iam_resources && var.create_eks ? 1 : 0
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSServicePolicy"
  role       = local.cluster_iam_role_name
}

#### Generate KubeConfig File ####
resource "local_file" "kubeconfig" {
  count    = var.write_kubeconfig && var.create_eks ? 1 : 0
  content  = data.template_file.kubeconfig[0].rendered
  filename = substr(var.config_output_path, -1, 1) == "/" ? "${var.config_output_path}kubeconfig_${var.cluster_name}" : var.config_output_path
}

resource "null_resource" "update_kube_config" {
  count    = var.write_kubeconfig && var.create_eks ? 1 : 0

  depends_on = [
    aws_eks_cluster.arqref[0],
    local_file.kubeconfig[0],
  ]

  provisioner "local-exec" {
    command     = var.eks_update_kubeconfig
    interpreter = var.wait_for_cluster_interpreter
    environment = {
      CLUSTER = aws_eks_cluster.arqref[0].name
      PROFILE = var.aws_profile
      REGION  = data.aws_region.current.name
    }
  }
}


#### Enable OIDC Provider for IAM permissions for Pods ###
#
#Enable IAM Roles for EKS Service-Accounts (IRSA).

# The Root CA Thumbprint for an OpenID Connect Identity Provider is currently
# Being passed as a default value which is the same for all regions and
# Is valid until (Jun 28 17:39:16 2034 GMT).
# https://crt.sh/?q=9E99A48A9960B14926BB7F3B02E22DA2B0AB7280
# https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
# https://github.com/terraform-providers/terraform-provider-aws/issues/10104

data "aws_region" "current" {}
# Fetch OIDC provider thumbprint for root CA
data "external" "thumbprint" {
  program = ["sh","${path.module}/scripts/oidc-thumbprint.sh", data.aws_region.current.name]

}


resource "aws_iam_openid_connect_provider" "oidc_provider" {
  count           = var.enable_irsa && var.create_eks ? 1 : 0
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = concat([data.external.thumbprint.result.thumbprint], var.eks_oidc_root_ca_thumbprint)
  url             = flatten(concat(aws_eks_cluster.arqref[*].identity[*].oidc.0.issuer, [""]))[0]
}


####   Config Users and Roles for EKS ######

data "aws_caller_identity" "current" {
}


resource "kubernetes_config_map" "aws_auth" {
  count      = var.create_eks && var.manage_aws_auth ? 1 : 0
  depends_on = [null_resource.wait_for_cluster[0]]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode(
      distinct(concat(
        local.configmap_roles,
        var.map_roles,
      ))
    )
    mapUsers    = yamlencode(var.map_users)
    mapAccounts = yamlencode(var.map_accounts)
  }
}
