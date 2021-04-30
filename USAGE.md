## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cased-shell-container-definition"></a> [cased-shell-container-definition](#module\_cased-shell-container-definition) | cloudposse/ecs-container-definition/aws | 0.21.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_service.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs-task-execution-role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.read-secrets-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.ecs-task-execution-role-attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lb.cased-shell-nlb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.cased-shell-listener-443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.cased-shell-listener-80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.cased-shell-target-443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.cased-shell-target-80](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route53_record.cased-shell](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_iam_policy_document.ecs-tasks-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.read-secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cased_shell_secret_arn"></a> [cased\_shell\_secret\_arn](#input\_cased\_shell\_secret\_arn) | The ARN of a secret used for the CASED\_SHELL\_SECRET env variable | `string` | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | The id of the ECS cluster where the service will be deployed. | `string` | n/a | yes |
| <a name="input_container_subnet_ids"></a> [container\_subnet\_ids](#input\_container\_subnet\_ids) | A list of subnet ids that will be used for the container. | `list(string)` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | The environment you will use. This is used to preface various names. | `string` | n/a | yes |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | The hostname of the Cased Shell deployment, without protocol (e.g., 'webshell.example.com') | `string` | n/a | yes |
| <a name="input_nlb_subnet_ids"></a> [nlb\_subnet\_ids](#input\_nlb\_subnet\_ids) | A list of subnet ids that will be used for the NLB. | `list(string)` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | A list of security group ids that will be used for the container. | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The id of the VPC for the NLB and the VPC. | `string` | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | The Route53 apex zone id which will be associated with the hostname entry | `string` | n/a | yes |
| <a name="input_cased_remote_hostname"></a> [cased\_remote\_hostname](#input\_cased\_remote\_hostname) | The hostname of the Cased remote server, without protocol (e.g., 'cased.com') | `string` | `"cased.com"` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | The CPU allocated to the container | `number` | `180` | no |
| <a name="input_grace_period"></a> [grace\_period](#input\_grace\_period) | Startup grace period, or the duration of time the application is expected to fail health checks on startup | `number` | `360` | no |
| <a name="input_http_health_check"></a> [http\_health\_check](#input\_http\_health\_check) | n/a | <pre>list(object({<br>    healthy_threshold   = number<br>    path                = string<br>    port                = number<br>    unhealthy_threshold = number<br>  }))</pre> | <pre>[<br>  {<br>    "healthy_threshold": 2,<br>    "path": "/_health",<br>    "port": "80",<br>    "unhealthy_threshold": 2<br>  }<br>]</pre> | no |
| <a name="input_https_health_check"></a> [https\_health\_check](#input\_https\_health\_check) | n/a | <pre>list(object({<br>    healthy_threshold   = number<br>    path                = string<br>    port                = number<br>    unhealthy_threshold = number<br>  }))</pre> | <pre>[<br>  {<br>    "healthy_threshold": 2,<br>    "path": "/_health",<br>    "port": "80",<br>    "unhealthy_threshold": 2<br>  }<br>]</pre> | no |
| <a name="input_image"></a> [image](#input\_image) | The container image to use | `string` | `"casedhub/shell:0.5.0"` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | Log level | `string` | `"error"` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | The memory in MB allocated to the container | `number` | `1024` | no |
| <a name="input_ssh_key_arn"></a> [ssh\_key\_arn](#input\_ssh\_key\_arn) | The ARN of a secret used for the CASED\_SHELL\_SSH\_PRIVATE\_KEY env variable | `string` | `null` | no |
| <a name="input_ssh_passphrase_arn"></a> [ssh\_passphrase\_arn](#input\_ssh\_passphrase\_arn) | The string passphrase used for the CASED\_SHELL\_SSH\_PASSPHRASE env variable | `string` | `null` | no |
| <a name="input_ssh_username"></a> [ssh\_username](#input\_ssh\_username) | The string username used for the CASED\_SHELL\_SSH\_USERNAME env variable | `string` | `null` | no |

## Outputs

No outputs.
