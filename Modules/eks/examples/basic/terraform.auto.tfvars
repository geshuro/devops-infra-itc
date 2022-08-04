
vpc_id = "vpc-0da00bfd899148ac6"
private_subnets = ["subnet-03fa3fdc95b616741", "subnet-046b0d1f6ba7227a7", "subnet-0bfaa82331efc68a0"]

map_accounts = [
    "711992207767"
  ]
map_roles = [
    {
      rolearn  = "arn:aws:iam::711992207767:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
map_users = [
    {
      userarn  = "arn:aws:iam::711992207767:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::711992207767:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]