# The container definition used for Cased Shell
module "cased-shell-awscli-sidecar-definition" {
  # TODO once we drop support for 0.12
  # count   = var.host_autodiscovery ? 1 : 0
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.21.0"

  entrypoint                   = ["/bin/bash", "-c"]
  command                      = ["aws sts get-caller-identity --output text && while true; do aws ec2 describe-instances ${local.host_autodiscovery_tag_filter_command} --query 'Reservations[*].Instances[*].[PrivateDnsName,Tags[?Key==`${var.host_autodiscovery_descriptive_tag}`] | [0].Value]' --output text | tr '\\t' ',' > /opt/cased/tmp/hosts; sleep ${var.host_autodiscovery_refresh_interval}; done"]
  container_name               = "${local.base_name}-host-autodiscovery"
  container_image              = "amazon/aws-cli"
  container_memory             = 512
  container_memory_reservation = 64
  container_cpu                = 100
  port_mappings                = []
  mount_points = [
    {
      sourceVolume  = "scratch"
      containerPath = "/opt/cased/tmp"
    }
  ]
}


data "aws_iam_policy_document" "describe-instances-policy" {
  count = var.host_autodiscovery ? 1 : 0
  statement {
    actions   = ["ec2:DescribeInstances"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "ecs-task-role" {
  count              = var.host_autodiscovery ? 1 : 0
  name               = "ecs-task-role-${local.base_name}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-tasks-policy.json
}

# Add the describe-instances policy to the ecs task execution role
resource "aws_iam_role_policy" "describe-instances-role-policy" {
  count  = var.host_autodiscovery ? 1 : 0
  policy = data.aws_iam_policy_document.describe-instances-policy.0.json
  role   = aws_iam_role.ecs-task-role.0.id
}

locals {
  host_discovery_environment = {
    name  = "CASED_SHELL_HOST_FILE"
    value = "/opt/cased/tmp/hosts"
  }

  host_discovery_mount_point = {
    sourceVolume  = "scratch"
    containerPath = "/opt/cased/tmp"
  }

  host_autodiscovery_tag_filter_command = join(" ", flatten([
    for f in var.host_autodiscovery_tag_filters : [
      format("--filters 'Name=tag:%s,Values=%s'", f.name, join(",", f.values))
    ]
  ]))
}