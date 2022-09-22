data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  #load_config_file       = false
  #version                = "~> 1.7"
}

provider "helm" {
  #version = "~>1.0.0"
  debug = true
  alias = "helm"

  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token
    load_config_file       = false
  }
}

data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    profile        = var.BackendProfile
    bucket         = var.BackendS3
    key            = "terraform/${var.Environment}"
    region         = var.BackendRegion
    encrypt        = true
    dynamodb_table = var.BackendDynamoDB // Nombre de la tabla que almacena el estado de terraform.
  }
  workspace = "networking"
}

data "aws_availability_zones" "available" {
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "eks" {
  source       = "../../Modules/eks"
  cluster_name = local.cluster_name
  cluster_version = var.cluster_version
  subnets      = data.terraform_remote_state.networking.outputs.private_2_subnet-id
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true
  //cluster_endpoint_private_access_cidrs = data.terraform_remote_state.networking.outputs.

  tags = local.tags

  vpc_id = data.terraform_remote_state.networking.outputs.vpc_id

  node_groups_defaults = var.node_groups_defaults

  node_groups = {
    devops = {
      desired_capacity = 1
      max_capacity     = 4
      min_capacity     = 1

      instance_type = "t3a.large"
      //k8s_labels = local.tags
    },
    devops2 = {
      desired_capacity = 1
      max_capacity     = 4
      min_capacity     = 1

      instance_type = "t3a.large"
      //k8s_labels = local.tags
    }
  }
  /*
  worker_groups = [
    {
      name                          = "devops-worker-group"
      instance_type                 = var.instance_type
      additional_userdata           = "echo EKS Worker Node"
      asg_desired_capacity          = var.desired_capacity
      asg_max_size                  = var.max_size
      asg_min_size                  = var.min_size
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      worker_groups        = {
        tags = local.tags
      }
    },
    {
      name                          = "devops-worker-group-2"
      instance_type                 = var.instance_type
      additional_userdata           = "echo EKS Worker Node 2"
      asg_desired_capacity          = 1
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      worker_groups        = {
        tags = local.tags
      }
    }
  ] 
  */

  workers_additional_policies = ["arn:aws:iam::aws:policy/AmazonS3FullAccess"]

  map_roles    = var.map_roles
  map_users    = var.map_users
  map_accounts = var.map_accounts
  aws_profile  = local.profile
  Environment  = var.Environment
  
  #####   Enabling AutoScaling Schedule   ############
  #aws_autoscaling_schedule
  enabledcronweekend    = false
  cronweekendup         = {
    cron       = "0 6 * * MON"
    start_time = "2022-06-19T18:00:00Z"
    end_time   = "2030-06-19T18:00:00Z"
  }
  cronweekenddown       = {
    cron       = "0 17 * * FRI"
    start_time = "2020-06-19T18:00:30Z"
    end_time   = "2030-06-19T18:00:30Z"
  }

  enabledcrondaily = true
  crondailyup         = {
    cron       = "0 6 * * 1-5"
    start_time = "2022-08-31T06:00:00Z"
    end_time   = "2023-08-31T17:00:00Z"
  }
  crondailydown       = {
    cron       = "0 17 * * 1-5"
    start_time = "2023-08-31T17:00:00Z"
    end_time   = "2023-08-31T17:00:00Z"
  }
}

resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = "worker_group_mgmt_one"
  vpc_id = data.terraform_remote_state.networking.outputs.vpc_id

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"

    cidr_blocks = [
      data.terraform_remote_state.networking.outputs.vpc_cidr_block,
    ]
  }
}

module kubernetes-extras {
  source                  = "../../Modules/eks/modules/ke2"
  is_eks                  = true
  install_helm            = true
  install_metrics_server  = false
  install_dashboard       = false
  install_alb_ingress     = false
  install_grafana         = false
  install_prometheus      = false
  install_istio           = false
  install_efs_provisioner = false

  cluster_name = local.cluster_name
  project = var.project
  environment = var.Environment
  aws_region = var.region

  vpc_id            = data.terraform_remote_state.networking.outputs.vpc_id
  worker_subnet_ids = data.terraform_remote_state.networking.outputs.private_2_subnet-id

  oidc_provider_url = substr(data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer, 8, length(data.aws_eks_cluster.cluster.identity.0.oidc.0.issuer))

  fs_id = ""

  tags = local.tags

  depend_on = [module.eks]
}