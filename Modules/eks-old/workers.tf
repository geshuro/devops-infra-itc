data "aws_iam_policy_document" "workers_assume_role_policy" {
  statement {
    sid = "EKSWorkerAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = [local.ec2_principal]
    }
  }
}

data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = [local.worker_ami_name_filter]
  }

  most_recent = true

  owners = [var.worker_ami_owner_id]
}

data "aws_ami" "eks_worker_windows" {
  filter {
    name   = "name"
    values = [local.worker_ami_name_filter_windows]
  }

  filter {
    name   = "platform"
    values = ["windows"]
  }

  most_recent = true

  owners = [var.worker_ami_owner_id_windows]
}

data "template_file" "userdata" {
  count = var.create_eks ? local.worker_group_count : 0
  template = lookup(
    var.worker_groups[count.index],
    "userdata_template_file",
    file(
      lookup(var.worker_groups[count.index], "platform", local.workers_group_defaults["platform"]) == "windows"
      ? "${path.module}/templates/userdata_windows.tpl"
      : "${path.module}/templates/userdata.sh.tpl"
    )
  )

  vars = merge({
    platform            = lookup(var.worker_groups[count.index], "platform", local.workers_group_defaults["platform"])
    cluster_name        = aws_eks_cluster.arqref[0].name
    endpoint            = aws_eks_cluster.arqref[0].endpoint
    cluster_auth_base64 = aws_eks_cluster.arqref[0].certificate_authority[0].data
    pre_userdata = lookup(
      var.worker_groups[count.index],
      "pre_userdata",
      local.workers_group_defaults["pre_userdata"],
    )
    additional_userdata = lookup(
      var.worker_groups[count.index],
      "additional_userdata",
      local.workers_group_defaults["additional_userdata"],
    )
    bootstrap_extra_args = lookup(
      var.worker_groups[count.index],
      "bootstrap_extra_args",
      local.workers_group_defaults["bootstrap_extra_args"],
    )
    kubelet_extra_args = lookup(
      var.worker_groups[count.index],
      "kubelet_extra_args",
      local.workers_group_defaults["kubelet_extra_args"],
    )
    },
    lookup(
      var.worker_groups[count.index],
      "userdata_template_extra_args",
      local.workers_group_defaults["userdata_template_extra_args"]
    )
  )
}

data "template_file" "launch_template_userdata" {
  count = var.create_eks ? local.worker_group_launch_template_count : 0
  template = lookup(
    var.worker_groups_launch_template[count.index],
    "userdata_template_file",
    file(
      lookup(var.worker_groups_launch_template[count.index], "platform", local.workers_group_defaults["platform"]) == "windows"
      ? "${path.module}/templates/userdata_windows.tpl"
      : "${path.module}/templates/userdata.sh.tpl"
    )
  )

  vars = merge({
    platform            = lookup(var.worker_groups_launch_template[count.index], "platform", local.workers_group_defaults["platform"])
    cluster_name        = aws_eks_cluster.arqref[0].name
    endpoint            = aws_eks_cluster.arqref[0].endpoint
    cluster_auth_base64 = aws_eks_cluster.arqref[0].certificate_authority[0].data
    pre_userdata = lookup(
      var.worker_groups_launch_template[count.index],
      "pre_userdata",
      local.workers_group_defaults["pre_userdata"],
    )
    additional_userdata = lookup(
      var.worker_groups_launch_template[count.index],
      "additional_userdata",
      local.workers_group_defaults["additional_userdata"],
    )
    bootstrap_extra_args = lookup(
      var.worker_groups_launch_template[count.index],
      "bootstrap_extra_args",
      local.workers_group_defaults["bootstrap_extra_args"],
    )
    kubelet_extra_args = lookup(
      var.worker_groups_launch_template[count.index],
      "kubelet_extra_args",
      local.workers_group_defaults["kubelet_extra_args"],
    )
    },
    lookup(
      var.worker_groups_launch_template[count.index],
      "userdata_template_extra_args",
      local.workers_group_defaults["userdata_template_extra_args"]
    )
  )
}

data "aws_iam_instance_profile" "custom_worker_group_iam_instance_profile" {
  count = var.manage_worker_iam_resources ? 0 : local.worker_group_count
  name = lookup(
    var.worker_groups[count.index],
    "iam_instance_profile_name",
    local.workers_group_defaults["iam_instance_profile_name"],
  )
}

data "aws_iam_instance_profile" "custom_worker_group_launch_template_iam_instance_profile" {
  count = var.manage_worker_iam_resources ? 0 : local.worker_group_launch_template_count
  name = lookup(
    var.worker_groups_launch_template[count.index],
    "iam_instance_profile_name",
    local.workers_group_defaults["iam_instance_profile_name"],
  )
}

data "aws_partition" "current" {}


resource "random_string" "random" {
  length    = 4
  min_lower = 4
  special   = false
}


# Creacion de los Key Pair de los nodos

module "aws_key_pair" {
  source              = "../keypair"
  namespace           = "kp"
  stage               = ""
  name                = var.cluster_name
  attributes          = [random_string.random.result]
  delimiter           = "-"
  ssh_public_key_path = "./secret"
  generate_ssh_key    = true
}

# Subida de datos a SSM de los Keypair
module "ssm-key-pair" {
   source      = "../ssm-parameter"
   name        = "/${var.Environment}/keypair/${module.aws_key_pair.key_name}/ssh-public"
   description = "The parameter description"
   type        = "SecureString"
   value       = module.aws_key_pair.private_key

   tags = var.tags
}

# Worker Groups using Launch Configurations

resource "aws_autoscaling_group" "workers" {
  count = var.create_eks ? local.worker_group_count : 0
  name_prefix = join(
    "-",
    compact(
      [
        aws_eks_cluster.arqref[0].name,
        lookup(var.worker_groups[count.index], "name", count.index),
        lookup(var.worker_groups[count.index], "asg_recreate_on_change", local.workers_group_defaults["asg_recreate_on_change"]) ? random_pet.workers[count.index].id : ""
      ]
    )
  )
  desired_capacity = lookup(
    var.worker_groups[count.index],
    "asg_desired_capacity",
    local.workers_group_defaults["asg_desired_capacity"],
  )
  max_size = lookup(
    var.worker_groups[count.index],
    "asg_max_size",
    local.workers_group_defaults["asg_max_size"],
  )
  min_size = lookup(
    var.worker_groups[count.index],
    "asg_min_size",
    local.workers_group_defaults["asg_min_size"],
  )
  force_delete = lookup(
    var.worker_groups[count.index],
    "asg_force_delete",
    local.workers_group_defaults["asg_force_delete"],
  )
  target_group_arns = lookup(
    var.worker_groups[count.index],
    "target_group_arns",
    local.workers_group_defaults["target_group_arns"]
  )
  service_linked_role_arn = lookup(
    var.worker_groups[count.index],
    "service_linked_role_arn",
    local.workers_group_defaults["service_linked_role_arn"],
  )
  launch_configuration = aws_launch_configuration.workers.*.id[count.index]
  vpc_zone_identifier = lookup(
    var.worker_groups[count.index],
    "subnets",
    local.workers_group_defaults["subnets"]
  )
  protect_from_scale_in = lookup(
    var.worker_groups[count.index],
    "protect_from_scale_in",
    local.workers_group_defaults["protect_from_scale_in"],
  )
  suspended_processes = lookup(
    var.worker_groups[count.index],
    "suspended_processes",
    local.workers_group_defaults["suspended_processes"]
  )
  enabled_metrics = lookup(
    var.worker_groups[count.index],
    "enabled_metrics",
    local.workers_group_defaults["enabled_metrics"]
  )
  placement_group = lookup(
    var.worker_groups[count.index],
    "placement_group",
    local.workers_group_defaults["placement_group"],
  )
  termination_policies = lookup(
    var.worker_groups[count.index],
    "termination_policies",
    local.workers_group_defaults["termination_policies"]
  )
  max_instance_lifetime = lookup(
    var.worker_groups[count.index],
    "max_instance_lifetime",
    local.workers_group_defaults["max_instance_lifetime"],
  )
  default_cooldown = lookup(
    var.worker_groups[count.index],
    "default_cooldown",
    local.workers_group_defaults["default_cooldown"]
  )
  health_check_grace_period = lookup(
    var.worker_groups[count.index],
    "health_check_grace_period",
    local.workers_group_defaults["health_check_grace_period"]
  )

  dynamic "initial_lifecycle_hook" {
    for_each = var.worker_create_initial_lifecycle_hooks ? lookup(var.worker_groups[count.index], "asg_initial_lifecycle_hooks", local.workers_group_defaults["asg_initial_lifecycle_hooks"]) : []
    content {
      name                    = initial_lifecycle_hook.value["name"]
      lifecycle_transition    = initial_lifecycle_hook.value["lifecycle_transition"]
      notification_metadata   = lookup(initial_lifecycle_hook.value, "notification_metadata", null)
      heartbeat_timeout       = lookup(initial_lifecycle_hook.value, "heartbeat_timeout", null)
      notification_target_arn = lookup(initial_lifecycle_hook.value, "notification_target_arn", null)
      role_arn                = lookup(initial_lifecycle_hook.value, "role_arn", null)
      default_result          = lookup(initial_lifecycle_hook.value, "default_result", null)
    }
  }

  tags = concat(
    [
      {
        "key"                 = "Name"
        "value"               = "${aws_eks_cluster.arqref[0].name}-${lookup(var.worker_groups[count.index], "name", count.index)}-eks_asg"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "kubernetes.io/cluster/${aws_eks_cluster.arqref[0].name}"
        "value"               = "owned"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "k8s.io/cluster/${aws_eks_cluster.arqref[0].name}"
        "value"               = "owned"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "Nodegroup"
        "value"               = "${aws_eks_cluster.arqref[0].name}-${lookup(var.worker_groups[count.index], "name", count.index)}-nodegroup"
        "propagate_at_launch" = true
      },
    ],
    local.asg_tags,
    lookup(
      var.worker_groups[count.index],
      "tags",
      local.workers_group_defaults["tags"]
    )
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}

resource "aws_launch_configuration" "workers" {
  count       = var.create_eks ? local.worker_group_count : 0
  name_prefix = "${aws_eks_cluster.arqref[0].name}-${lookup(var.worker_groups[count.index], "name", count.index)}"
  associate_public_ip_address = lookup(
    var.worker_groups[count.index],
    "public_ip",
    local.workers_group_defaults["public_ip"],
  )
  security_groups = flatten([
    local.worker_security_group_id,
    var.worker_additional_security_group_ids,
    lookup(
      var.worker_groups[count.index],
      "additional_security_group_ids",
      local.workers_group_defaults["additional_security_group_ids"]
    )
  ])
  iam_instance_profile = coalescelist(
    aws_iam_instance_profile.workers.*.id,
    data.aws_iam_instance_profile.custom_worker_group_iam_instance_profile.*.name,
  )[count.index]
  image_id = lookup(
    var.worker_groups[count.index],
    "ami_id",
    lookup(var.worker_groups[count.index], "platform", local.workers_group_defaults["platform"]) == "windows" ? local.default_ami_id_windows : local.default_ami_id_linux,
  )
  instance_type = lookup(
    var.worker_groups[count.index],
    "instance_type",
    local.workers_group_defaults["instance_type"],
  )
  # Changing key_name
  
  key_name = module.aws_key_pair.key_name

  # key_name = lookup(
  #   var.worker_groups[count.index],
  #   "key_name",
  #   local.workers_group_defaults["key_name"],
  # )
  
  user_data_base64 = base64encode(data.template_file.userdata.*.rendered[count.index])
  ebs_optimized = lookup(
    var.worker_groups[count.index],
    "ebs_optimized",
    ! contains(
      local.ebs_optimized_not_supported,
      lookup(
        var.worker_groups[count.index],
        "instance_type",
        local.workers_group_defaults["instance_type"]
      )
    )
  )
  enable_monitoring = lookup(
    var.worker_groups[count.index],
    "enable_monitoring",
    local.workers_group_defaults["enable_monitoring"],
  )
  spot_price = lookup(
    var.worker_groups[count.index],
    "spot_price",
    local.workers_group_defaults["spot_price"],
  )
  placement_tenancy = lookup(
    var.worker_groups[count.index],
    "placement_tenancy",
    local.workers_group_defaults["placement_tenancy"],
  )

  root_block_device {
    encrypted = lookup(
      var.worker_groups[count.index],
      "root_encrypted",
      local.workers_group_defaults["root_encrypted"],
    )
    volume_size = lookup(
      var.worker_groups[count.index],
      "root_volume_size",
      local.workers_group_defaults["root_volume_size"],
    )
    volume_type = lookup(
      var.worker_groups[count.index],
      "root_volume_type",
      local.workers_group_defaults["root_volume_type"],
    )
    iops = lookup(
      var.worker_groups[count.index],
      "root_iops",
      local.workers_group_defaults["root_iops"],
    )
    delete_on_termination = true
  }

  dynamic "ebs_block_device" {
    for_each = lookup(var.worker_groups[count.index], "additional_ebs_volumes", local.workers_group_defaults["additional_ebs_volumes"])

    content {
      device_name = ebs_block_device.value.block_device_name
      volume_size = lookup(
        ebs_block_device.value,
        "volume_size",
        local.workers_group_defaults["root_volume_size"],
      )
      volume_type = lookup(
        ebs_block_device.value,
        "volume_type",
        local.workers_group_defaults["root_volume_type"],
      )
      iops = lookup(
        ebs_block_device.value,
        "iops",
        local.workers_group_defaults["root_iops"],
      )
      encrypted = lookup(
        ebs_block_device.value,
        "encrypted",
        local.workers_group_defaults["root_encrypted"],
      )
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", true)
    }

  }

  lifecycle {
    create_before_destroy = true
  }
}
#####################    AutoScaling Scheduling  #########################################
resource "aws_autoscaling_schedule" "eks-down-weekend" {
  count = var.enabledcronweekend && var.create_eks ? local.worker_group_count : 0
  scheduled_action_name  = "eks-down-weekend"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = var.cronweekenddown.cron
  # start_time             = timeadd(timestamp(), "20m")      // var.cronweekenddown.start_time //"2020-06-19T18:00:00Z"
  end_time               = timeadd(timestamp(), "87600h2m") //: var.cronweekenddown.end_time//"2030-06-19T18:00:00Z"
  autoscaling_group_name = aws_autoscaling_group.workers[count.index].name
  lifecycle {
    #create_before_destroy = true
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      start_time,
      end_time
    ]
  }
}

resource "aws_autoscaling_schedule" "eks-up-weekend" {
  count = var.enabledcronweekend && var.create_eks ? local.worker_group_count : 0
  scheduled_action_name  = "eks-up-weekend"
  min_size               = lookup(
                           var.worker_groups[count.index],
                          "asg_min_size",
                           local.workers_group_defaults["asg_min_size"],
                          )
  max_size               = lookup(
                           var.worker_groups[count.index],
                           "asg_max_size",
                            local.workers_group_defaults["asg_max_size"],
                           )
  desired_capacity       = lookup(
                            var.worker_groups[count.index],
                            "asg_desired_capacity",
                            local.workers_group_defaults["asg_desired_capacity"],
                            )
  recurrence             = var.cronweekendup.cron           // == "" ? "6 0 * * MON" : var.cronweekendup.cron //"6 0 * * MON" // 0 23 * * MON-FRI
  # start_time             = timeadd(timestamp(), "25m")      //: var.cronweekendup.start_time //"2020-06-19T18:00:30Z"
  end_time               = timeadd(timestamp(), "87600h5m") //: var.cronweekendup.end_time //"2030-06-19T18:00:30Z"
  autoscaling_group_name = aws_autoscaling_group.workers[count.index].name
  lifecycle {
    #create_before_destroy = true
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      start_time,
      end_time
    ]
  }
}

#imendozah
resource "aws_autoscaling_schedule" "eks-down-daily" {
  count = var.enabledcrondaily && var.create_eks ? local.worker_group_count : 0
  scheduled_action_name  = "eks-down-daily"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = var.crondailydown.cron
  # start_time             = timeadd(timestamp(), "20m")      // var.cronweekenddown.start_time //"2020-06-19T18:00:00Z"
  end_time               = timeadd(timestamp(), "87600h2m") //: var.cronweekenddown.end_time//"2030-06-19T18:00:00Z"
  autoscaling_group_name = aws_autoscaling_group.workers[count.index].name
  lifecycle {
    #create_before_destroy = true
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      start_time,
      end_time
    ]
  }
}

resource "aws_autoscaling_schedule" "eks-up-daily" {
  count = var.enabledcrondaily && var.create_eks ? local.worker_group_count : 0
  scheduled_action_name  = "eks-up-daily"
  min_size               = lookup(
                           var.worker_groups[count.index],
                          "asg_min_size",
                           local.workers_group_defaults["asg_min_size"],
                          )
  max_size               = lookup(
                           var.worker_groups[count.index],
                           "asg_max_size",
                            local.workers_group_defaults["asg_max_size"],
                           )
  desired_capacity       = lookup(
                            var.worker_groups[count.index],
                            "asg_desired_capacity",
                            local.workers_group_defaults["asg_desired_capacity"],
                            )
  recurrence             = var.crondailyup.cron           // == "" ? "6 0 * * MON" : var.cronweekendup.cron //"6 0 * * MON" // 0 23 * * MON-FRI
  # start_time             = timeadd(timestamp(), "25m")      //: var.cronweekendup.start_time //"2020-06-19T18:00:30Z"
  end_time               = timeadd(timestamp(), "87600h5m") //: var.cronweekendup.end_time //"2030-06-19T18:00:30Z"
  autoscaling_group_name = aws_autoscaling_group.workers[count.index].name
  lifecycle {
    #create_before_destroy = true
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      start_time,
      end_time
    ]
  }
}

resource "random_pet" "workers" {
  count = var.create_eks ? local.worker_group_count : 0

  separator = "-"
  length    = 2

  keepers = {
    lc_name = aws_launch_configuration.workers[count.index].name
  }
}

resource "aws_security_group" "workers" {
  count       = var.worker_create_security_group && var.create_eks ? 1 : 0
  name_prefix = aws_eks_cluster.arqref[0].name
  description = "Security group for all nodes in the cluster."
  vpc_id      = var.vpc_id
  tags = merge(
    var.tags,
    {
      "Name"                                                  = "${aws_eks_cluster.arqref[0].name}-eks_worker_sg"
      "kubernetes.io/cluster/${aws_eks_cluster.arqref[0].name}" = "owned"
    },
  )
}

resource "aws_security_group_rule" "workers_egress_internet" {
  count             = var.worker_create_security_group && var.create_eks ? 1 : 0
  description       = "Allow nodes all egress to the Internet."
  protocol          = "-1"
  security_group_id = local.worker_security_group_id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "workers_ingress_self" {
  count                    = var.worker_create_security_group && var.create_eks ? 1 : 0
  description              = "Allow node to communicate with each other."
  protocol                 = "-1"
  security_group_id        = local.worker_security_group_id
  source_security_group_id = local.worker_security_group_id
  from_port                = 0
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_cluster" {
  count                    = var.worker_create_security_group && var.create_eks ? 1 : 0
  description              = "Allow workers pods to receive communication from the cluster control plane."
  protocol                 = "tcp"
  security_group_id        = local.worker_security_group_id
  source_security_group_id = local.cluster_security_group_id
  from_port                = var.worker_sg_ingress_from_port
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_cluster_kubelet" {
  count                    = var.worker_create_security_group && var.create_eks ? var.worker_sg_ingress_from_port > 10250 ? 1 : 0 : 0
  description              = "Allow workers Kubelets to receive communication from the cluster control plane."
  protocol                 = "tcp"
  security_group_id        = local.worker_security_group_id
  source_security_group_id = local.cluster_security_group_id
  from_port                = 10250
  to_port                  = 10250
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_cluster_https" {
  count                    = var.worker_create_security_group && var.create_eks ? 1 : 0
  description              = "Allow pods running extension API servers on port 443 to receive communication from cluster control plane."
  protocol                 = "tcp"
  security_group_id        = local.worker_security_group_id
  source_security_group_id = local.cluster_security_group_id
  from_port                = 443
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_iam_role" "workers" {
  count                 = var.manage_worker_iam_resources && var.create_eks ? 1 : 0
  name_prefix           = var.workers_role_name != "" ? null : aws_eks_cluster.arqref[0].name
  name                  = var.workers_role_name != "" ? var.workers_role_name : null
  assume_role_policy    = data.aws_iam_policy_document.workers_assume_role_policy.json
  permissions_boundary  = var.permissions_boundary
  path                  = var.iam_path
  force_detach_policies = true
  tags                  = var.tags
}

resource "aws_iam_instance_profile" "workers" {
  count       = var.manage_worker_iam_resources && var.create_eks ? local.worker_group_count : 0
  name_prefix = aws_eks_cluster.arqref[0].name
  role = lookup(
    var.worker_groups[count.index],
    "iam_role_id",
    local.default_iam_role_id,
  )

  path = var.iam_path
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKSWorkerNodePolicy" {
  count      = var.manage_worker_iam_resources && var.create_eks ? 1 : 0
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.workers[0].name
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKS_CNI_Policy" {
  count      = var.manage_worker_iam_resources && var.attach_worker_cni_policy && var.create_eks ? 1 : 0
  policy_arn = "${local.policy_arn_prefix}/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.workers[0].name
}

resource "aws_iam_role_policy_attachment" "workers_AmazonEC2ContainerRegistryReadOnly" {
  count      = var.manage_worker_iam_resources && var.create_eks ? 1 : 0
  policy_arn = "${local.policy_arn_prefix}/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.workers[0].name
}

resource "aws_iam_role_policy_attachment" "workers_additional_policies" {
  count      = var.manage_worker_iam_resources && var.create_eks ? length(var.workers_additional_policies) : 0
  role       = aws_iam_role.workers[0].name
  policy_arn = var.workers_additional_policies[count.index]
}