terraform-aws-cased-shell-ecs
------------------------------

Module to setup Cased Shell on ECS, featuring end-to-end encryption,
and using a Network Load Balancer.

See our [Terraform Registry docs](https://registry.terraform.io/modules/cased/cased-shell-ecs/aws/latest) for the input information and more.

Basic usage
------------------

```terraform
module "cased-shell" {
    source  = "cased/terraform-aws-cased-shell-ecs"
    version = "0.1.12"

    # The environment, and the id of the vpc and the cluster where the service will run
    env         = "prod"
    vpc_id      = vpc.id
    cluster_id  = mycluster.id

    # Subnets and secgroups for the service
    vpc_subnet_ids     = [subnet1.id, subnet2.id]
    security_group_ids = [securitygroup1.id, securitygroup2.id]

    # The hostname for Cased Shell
    hostname = "webshell.example.com"

    # For security, this must be the ARN of an aws_secretsmanager_secret, not the actual secret string
    cased_shell_secret_arn = your_shell_secret.arn

    # Set up a hostname with route53 automatically
    zone_id = your_zone.id
}
```

Custom variables
------------------

* `memory`. default is 1024MB
* `cpu`. default is 180

