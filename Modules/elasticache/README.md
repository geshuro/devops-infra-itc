## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| alarm\_cpu\_threshold | Alarm Elasticache CPU Threshold | `string` | `"80"` | no |
| alarm\_evictions\_threshold | Alarm Elasticache Evictions | `string` | `"1000"` | no |
| alarm\_memory\_threshold | Alarm Elasticache Memory Threshold | `string` | `"67108864"` | no |
| alarm\_replication\_lag\_threshold | Alarm Elasticache Evictions | `string` | `"1000"` | no |
| allowed\_cidr | A list of Security Group ID's to allow access to. | `list(string)` | <pre>[<br>  "127.0.0.1/32"<br>]</pre> | no |
| allowed\_security\_groups | A list of Security Group ID's to allow access to. | `list(string)` | `[]` | no |
| apply\_immediately | Specifies whether any modifications are applied immediately, or during the next maintenance window. Default is false. | `bool` | `false` | no |
| create\_security\_group | Create Elasticache Security Group Y/N | `bool` | `true` | no |
| ec\_subnet\_group\_name | Elasticache DB Subnet Name | `string` | `""` | no |
| name | Name for the Redis replication group i.e. UserObject | `string` | n/a | yes |
| redis\_clusters | Number of Redis cache clusters (nodes) to create | `string` | n/a | yes |
| redis\_failover | n/a | `bool` | `false` | no |
| redis\_maintenance\_window | Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period | `string` | `"fri:08:00-fri:09:00"` | no |
| redis\_node\_type | Instance type to use for creating the Redis cache clusters | `string` | `"cache.t2.micro"` | no |
| redis\_parameters | additional parameters modifyed in parameter group | `list(map(any))` | `[]` | no |
| redis\_port | n/a | `number` | `6379` | no |
| redis\_rest\_encryption\_enabled | Enable Encryption at Rest Elasticache | `bool` | `false` | no |
| redis\_snapshot\_retention\_limit | The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot\_retention\_limit is not supported on cache.t1.micro or cache.t2.* cache nodes | `number` | `0` | no |
| redis\_snapshot\_window | The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period | `string` | `"06:30-07:30"` | no |
| redis\_transit\_encryption\_enabled | Enable Encryption at Rest Elasticache | `bool` | `false` | no |
| redis\_version | Redis version to use, defaults to 3.2.10 | `string` | `"3.2.10"` | no |
| sns\_topic\_arn\_alarm | SNS Topic to CloudWatch Alarms | `list(string)` | <pre>[<br>  "arn:aws:sns:eu-west-1:175145454340:sns-rds-default-aurora-mysql-aju"<br>]</pre> | no |
| subnet\_ids | List of VPC Subnet IDs for the cache subnet group | `list(string)` | n/a | yes |
| tags | A map of tags to add to all resources. | `map(string)` | <pre>{<br>  "CostCenter": "",<br>  "Enviroment": "pro",<br>  "ProjectId": "",<br>  "ServiceId": ""<br>}</pre> | no |
| vpcName | VPC Name | `string` | n/a | yes |
| vpc\_id | VPC ID | `string` | n/a | yes |
| zone\_name | Internal DNS zone id | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| dns\_name\_cluster | n/a |
| endpoint | n/a |
| id | n/a |
| parameter\_group | n/a |
| port | n/a |
| redis\_security\_group\_id | n/a |
| redis\_subnet\_group\_name | n/a |

