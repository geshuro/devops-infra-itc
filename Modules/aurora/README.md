## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.0 |
| random | ~> 2.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| allowed\_cidr\_blocks | A list of CIDR blocks which are allowed to access the database | `list(string)` | `[]` | no |
| allowed\_security\_groups | A list of Security Group ID's to allow access to. | `list(string)` | `[]` | no |
| auto\_minor\_version\_upgrade | Determines whether minor engine upgrades will be performed automatically in the maintenance window | `bool` | `true` | no |
| backtrack\_window | The target backtrack window, in seconds. Only available for aurora engine currently. To disable backtracking, set aurora\_arqref value to 0. Defaults to 0. Must be between 0 and 259200 (72 hours) | `number` | `0` | no |
| backup\_retention\_period | How long to keep backups for (in days) | `number` | `7` | no |
| ca\_cert\_identifier | The identifier of the CA certificate for the DB instance | `string` | `"rds-ca-2019"` | no |
| cpu\_credit\_balance\_threshold | CPU credit balance threshold | `number` | `20` | no |
| cpu\_utilization\_threshold | CPU alarm DB Instance threshold | `number` | `80` | no |
| create\_security\_group | Whether to create security group for RDS cluster | `bool` | `true` | no |
| database\_name | Name for an automatically created database on cluster creation | `string` | `""` | no |
| db\_cluster\_mysql\_parameters | additional parameters mysql db modifyed in parameter group | `list(map(any))` | <pre>[<br>  {<br>    "name": "character_set_server",<br>    "value": "utf8"<br>  },<br>  {<br>    "name": "character_set_client",<br>    "value": "utf8"<br>  },<br>  {<br>    "name": "character_set_connection",<br>    "value": "utf8"<br>  },<br>  {<br>    "name": "character_set_database",<br>    "value": "utf8"<br>  },<br>  {<br>    "name": "character_set_filesystem",<br>    "value": "utf8"<br>  },<br>  {<br>    "name": "character_set_results",<br>    "value": "utf8"<br>  },<br>  {<br>    "name": "character_set_server",<br>    "value": "utf8"<br>  },<br>  {<br>    "name": "collation_connection",<br>    "value": "utf8_general_ci"<br>  },<br>  {<br>    "name": "collation_server",<br>    "value": "utf8_general_ci"<br>  }<br>]</pre> | no |
| db\_cluster\_parameter\_group\_name | The name of a DB Cluster parameter group to use | `string` | `""` | no |
| db\_mysql\_parameters | additional parameters mysql db modifyed in parameter group | `list(map(any))` | <pre>[<br>  {<br>    "name": "log_bin_trust_function_creators",<br>    "value": "1"<br>  },<br>  {<br>    "name": "innodb_print_all_deadlocks",<br>    "value": "1"<br>  },<br>  {<br>    "name": "max_allowed_packet",<br>    "value": "1073741824"<br>  },<br>  {<br>    "name": "event_scheduler",<br>    "value": "ON"<br>  },<br>  {<br>    "name": "interactive_timeout",<br>    "value": "28800"<br>  }<br>]</pre> | no |
| db\_parameter\_group\_name | The name of a DB parameter group to use | `string` | `""` | no |
| db\_subnet\_group\_name | The existing subnet group name to use | `string` | `""` | no |
| enabled\_cloudwatch\_logs\_exports | List of log types to export to cloudwatch | `list(string)` | <pre>[<br>  "postgresql"<br>]</pre> | no |
| engine | Aurora database engine type, currently aurora, aurora-mysql or aurora-postgresql | `string` | `"aurora"` | no |
| engine\_family | Aurora database engine family - Db Parameters Group | `string` | `"aurora-postgresql11"` | no |
| engine\_mode | The database engine mode. Valid values: global, parallelquery, provisioned, serverless. | `string` | `"provisioned"` | no |
| engine\_version | Aurora database engine version. | `string` | `"5.6.10a"` | no |
| final\_snapshot\_identifier\_prefix | The prefix name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too. | `string` | `"final"` | no |
| free\_storage\_space\_threshold | The minimum amount of available storage space in Byte. | `string` | `2000000000` | no |
| freeable\_memory\_threshold | The minimum amount of available random access memory in Byte. | `string` | `64000000` | no |
| global\_cluster\_identifier | The global cluster identifier specified on aws\_rds\_global\_cluster | `string` | `""` | no |
| iam\_database\_authentication\_enabled | Specifies whether IAM Database authentication should be enabled or not. Not all versions and instances are supported. Refer to the AWS documentation to see which versions are supported. | `bool` | `false` | no |
| iam\_roles | A List of ARNs for the IAM roles to associate to the RDS Cluster. | `list(string)` | `[]` | no |
| instance\_type | Instance type to use | `string` | n/a | yes |
| kms\_key\_id | The ARN for the KMS encryption key if one is set to the cluster. | `string` | `""` | no |
| monitoring\_interval | The interval (seconds) between points when Enhanced Monitoring metrics are collected | `number` | `60` | no |
| name | Name given resources | `string` | n/a | yes |
| password | Master DB password | `string` | `""` | no |
| port | The port on which to accept connections | `string` | `""` | no |
| preferred\_backup\_window | When to perform DB backups | `string` | `"02:00-03:00"` | no |
| preferred\_maintenance\_window | When to perform DB maintenance | `string` | `"sun:05:00-sun:06:00"` | no |
| publicly\_accessible | Whether the DB should have a public IP address | `bool` | `false` | no |
| replica\_count | Number of reader nodes to create.  If `replica_scale_enable` is `true`, the value of `replica_scale_min` is used instead. | `number` | `1` | no |
| replication\_source\_identifier | ARN of a source DB cluster or DB instance if aurora\_arqref DB cluster is to be created as a Read Replica. | `string` | `""` | no |
| secret\_name | Name of secret to store | `string` | `""` | no |
| secret\_values | Db Secrets | `map` | <pre>{<br>  "password": "123456789",<br>  "username": "root"<br>}</pre> | no |
| security\_group\_description | The description of the security group. If value is set to empty string it will contain cluster name in the description. | `string` | `"Managed by Terraform"` | no |
| skip\_final\_snapshot | Should a final snapshot be created on cluster destroy | `bool` | `false` | no |
| source\_region | The source region for an encrypted replica DB cluster. | `string` | `""` | no |
| storage\_encrypted | Specifies whether the underlying storage layer should be encrypted | `bool` | `true` | no |
| subnets | List of subnet IDs to use | `list(string)` | `[]` | no |
| tags | A map of tags to add to all resources. | `map(string)` | <pre>{<br>  "CostCenter": "",<br>  "Enviroment": "pro",<br>  "ProjectId": "",<br>  "ServiceId": ""<br>}</pre> | no |
| username | Master DB username | `string` | `"root"` | no |
| vpcName | VPC Name | `string` | n/a | yes |
| vpc\_id | VPC ID | `string` | n/a | yes |
| vpc\_security\_group\_ids | List of VPC security groups to associate to the cluster in addition to the SG we create in aurora\_arqref module | `list(string)` | `[]` | no |
| zone\_name | Internal DNS zone id | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| aurora\_arqref\_rds\_cluster\_arn | The ID of the cluster |
| aurora\_arqref\_rds\_cluster\_database\_name | Name for an automatically created database on cluster creation |
| aurora\_arqref\_rds\_cluster\_endpoint | The cluster endpoint |
| aurora\_arqref\_rds\_cluster\_id | The ID of the cluster |
| aurora\_arqref\_rds\_cluster\_instance\_endpoints | A list of all cluster instance endpoints |
| aurora\_arqref\_rds\_cluster\_master\_password | The master password |
| aurora\_arqref\_rds\_cluster\_master\_username | The master username |
| aurora\_arqref\_rds\_cluster\_port | The port |
| aurora\_arqref\_rds\_cluster\_reader\_endpoint | The cluster reader endpoint |
| aurora\_arqref\_rds\_cluster\_resource\_id | The Resource ID of the cluster |
| aurora\_arqref\_security\_group\_id | The security group ID of the cluster |
| dns\_name\_cluster | n/a |
| dns\_name\_cluster\_reader | n/a |

