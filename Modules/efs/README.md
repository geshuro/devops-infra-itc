## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| create\_security\_group | Flag to create EFS security Group | `bool` | `true` | no |
| name | A unique name (a maximum of 64 characters are allowed) used as reference when creating the Elastic File System to ensure idempotent file system creation. | `string` | n/a | yes |
| security\_group\_egress | Can be specified multiple times for each egress rule. | <pre>list(object({<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    self        = bool<br>    cidr_blocks = list(string)<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_blocks": [<br>      "0.0.0.0/0"<br>    ],<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "self": false,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| security\_group\_ingress | Can be specified multiple times for each ingress rule. | <pre>list(object({<br>    from_port   = number<br>    protocol    = string<br>    to_port     = number<br>    self        = bool<br>    # cidr_blocks = list(string)<br>    source_security_group_id  = list(string) <br>  }))</pre> | <pre>[<br>  {<br>    "from_port": 2049,<br>    "protocol": "tcp",<br>    "self": true,<br>    "source_security_group_id": [<br>      "sg-4133000d"<br>    ],<br>    "to_port": 2049<br>  }<br>]</pre> | no |
| subnet\_ids | Subnet IDs for Mount Targets | `list(string)` | n/a | yes |
| tags | A map of tags to add to all resources. | `map(string)` | <pre>{<br>  "CostCenter": "",<br>  "Enviroment": "pro",<br>  "ProjectId": "",<br>  "ServiceId": ""<br>}</pre> | no |
| vpcName | Name of the VPC wil EFS will be deply | `string` | n/a | yes |
| vpc\_id | The name of the VPC that EFS will be deployed to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | EFS ARN |
| dns\_name | EFS DNS name |
| id | EFS ID |
| mount\_target\_ids | List of EFS mount target IDs (one per Availability Zone) |
| security\_group\_arn | EFS Security Group ARN |
| security\_group\_id | EFS Security Group ID |
| security\_group\_name | EFS Security Group name |

