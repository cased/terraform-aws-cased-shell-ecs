# terraform-aws-cased-shell-ecs

Module to setup Cased Shell on ECS, featuring end-to-end encryption,
and using a Network Load Balancer.

## Example

```terraform
module "cased-shell" {
    source  = "cased/terraform-aws-cased-shell-ecs"
    version = "~> 0.4.0"

    # The environment, and the id of the vpc and the cluster where the service will run
    env         = "prod"
    vpc_id      = vpc.id
    cluster_id  = cluster.id

    # Subnets and security groups for the service
    vpc_subnet_ids     = [subnet1.id, subnet2.id]
    security_group_ids = [securitygroup1.id, securitygroup2.id]

    # The hostname for Cased Shell
    hostname = "shell.example.com"

    # For security, this must be the ARN of an aws_secretsmanager_secret, not the actual secret string
    cased_shell_secret_arn = your_shell_secret.arn

    # Set up a hostname with route53 automatically
    zone_id = your_zone.id
}
```

## Documentation

- [Usage documentation](./USAGE.md)
- [Terraform Registry](https://registry.terraform.io/modules/cased/cased-shell-ecs/aws/latest)

## Host and Container auto-discovery

By default, the hosts a Cased Shell instance can be used to access are configured in the Cased App. To configure Cased Shell to automatically discovery nearby instances and containers, this module accepts a `jump_queries` parameter containing a list of Jump Queries as described in the [documentation for the Jump utility](https://github.com/cased/jump/pkgs/container/jump).

### Examples

```terraform
    jump_queries = [
      {
        provider = "ec2"
        filters = {
            "tag:aws:autoscaling:groupName" = "*test*"
        }
        prompt = {
          description = "Test cluster instances"
          labels = {
            environment = "test"
          }
        }
      },
      {
        provider = "ecs"
        filters = {
          cluster = "test-cluster"
          task-group = "test-service"
        }
        limit = 1
        sortBy = "startedAt"
        sortOrder = "desc"
        prompt = {
          name = "Test Rails Console"
          description = "Use to perform exploratory debugging on the test cluster"
          shellCommand = "./bin/rails console"
          labels = {
            environment = "test"
          }
        }
      },
      {
        provider = "static"
        prompt = {
          description = "Static entries can be added using the static provider"
          hostname = "example.com"
          ipAddress = "192.0.2.1"
          port = "2222"
          username = "example"
          promptForKey = true
        }
      }
    ]
```

## Development

`make` will generate docs, format source, and run tests.
