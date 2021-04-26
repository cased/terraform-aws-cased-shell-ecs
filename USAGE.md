# Usage

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| cased-shell-container-definition | cloudposse/ecs-container-definition/aws | 0.21.0 |

## Resources

| Name |
|------|
| [aws_ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) |
| [aws_ecs_task_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) |
| [aws_iam_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_iam_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) |
| [aws_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) |
| [aws_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) |
| [aws_lb_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) |
| [aws_route53_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cased\_remote\_hostname | The hostname of the Cased remote server, without protocol (e.g., 'cased.com') | `string` | `"cased.com"` | no |
| cased\_shell\_secret\_arn | The ARN of a secret used for the CASED\_SHELL\_SECRET env variable | `string` | n/a | yes |
| cluster\_id | The id of the ECS cluster where the service will be deployed. | `string` | n/a | yes |
| container\_subnet\_ids | A list of subnet ids that will be used for the container. | `list(string)` | n/a | yes |
| cpu | The CPU allocated to the container | `number` | `180` | no |
| env | The environment you will use. This is used to preface various names. | `string` | n/a | yes |
| grace\_period | Startup grace period, or the duration of time the application is expected to fail health checks on startup | `number` | `360` | no |
| hostname | The hostname of the Cased Shell deployment, without protocol (e.g., 'webshell.example.com') | `string` | n/a | yes |
| http\_health\_check | n/a | <pre>list(object({<br>    healthy_threshold   = number<br>    path                = string<br>    port                = number<br>    unhealthy_threshold = number<br>  }))</pre> | <pre>[<br>  {<br>    "healthy_threshold": 2,<br>    "path": "/_health",<br>    "port": "80",<br>    "unhealthy_threshold": 2<br>  }<br>]</pre> | no |
| https\_health\_check | n/a | <pre>list(object({<br>    healthy_threshold   = number<br>    path                = string<br>    port                = number<br>    unhealthy_threshold = number<br>  }))</pre> | <pre>[<br>  {<br>    "healthy_threshold": 2,<br>    "path": "/_health",<br>    "port": "80",<br>    "unhealthy_threshold": 2<br>  }<br>]</pre> | no |
| image | The container image to use | `string` | `"casedhub/shell:0.5.0"` | no |
| log\_level | Log level | `string` | `"error"` | no |
| memory | The memory in MB allocated to the container | `number` | `1024` | no |
| nlb\_subnet\_ids | A list of subnet ids that will be used for the NLB. | `list(string)` | n/a | yes |
| security\_group\_ids | A list of security group ids that will be used for the container. | `list(string)` | n/a | yes |
| ssh\_key\_arn | The ARN of a secret used for the CASED\_SHELL\_SSH\_PRIVATE\_KEY env variable | `string` | `null` | no |
| ssh\_passphrase\_arn | The string passphrase used for the CASED\_SHELL\_SSH\_PASSPHRASE env variable | `string` | `null` | no |
| ssh\_username | The string username used for the CASED\_SHELL\_SSH\_USERNAME env variable | `string` | `null` | no |
| vpc\_id | The id of the VPC for the NLB and the VPC. | `string` | n/a | yes |
| zone\_id | The Route53 apex zone id which will be associated with the hostname entry | `string` | n/a | yes |

## Outputs

No output.

<!--- END_TF_DOCS --->

