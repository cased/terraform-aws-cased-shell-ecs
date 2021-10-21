module "cased-shell-jump-sidecar-definition" {
  # TODO once we drop support for 0.12
  # count   = var.jump_queries != [] ? 1 : 0
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.22.0"

  entrypoint                   = ["/bin/app", "/opt/cased/tmp/jump.yaml", "/opt/cased/tmp/jump.json"]
  container_name               = "${local.base_name}-jump"
  container_image              = var.jump_image
  container_memory             = 128
  container_memory_reservation = 64
  container_cpu                = 100
  port_mappings                = []
  essential                    = true
  container_depends_on = [{
    containerName = "${local.base_name}-jump-config",
    condition     = "SUCCESS"
  }]

  mount_points = [
    {
      sourceVolume  = "scratch"
      containerPath = "/opt/cased/tmp"
    }
  ]
}

module "cased-shell-jump-config-definition" {
  # TODO once we drop support for 0.12
  # count   = var.jump_queries != [] ? 1 : 0
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.22.0"

  entrypoint                   = ["/bin/bash", "-c"]
  container_name               = "${local.base_name}-jump-config"
  command                      = ["echo \"$YAML\" > /opt/cased/tmp/jump.yaml"]
  container_image              = "amazon/aws-cli"
  container_memory             = 64
  container_memory_reservation = 64
  container_cpu                = 10
  port_mappings                = []
  essential                    = false
  environment = [{
    name = "YAML",
    // lol
    value = jsonencode({
      queries : var.jump_queries
    })
  }]
  mount_points = [
    {
      sourceVolume  = "scratch"
      containerPath = "/opt/cased/tmp"
    }
  ]
}

data "aws_iam_policy_document" "describe-instances-policy" {
  count = var.jump_queries != [] ? 1 : 0
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ecs:ListTasks",
      "ecs:DescribeTasks",
      "ecs:ListContainerInstances",
      "ecs:DescribeContainerInstances",
    ]
    resources = ["*"]
  }
}

# Add the describe-instances policy to the ecs task execution role
resource "aws_iam_role_policy" "describe-instances-role-policy" {
  count  = var.jump_queries != [] ? 1 : 0
  policy = data.aws_iam_policy_document.describe-instances-policy.0.json
  role   = aws_iam_role.ecs-task-role.0.id
}

locals {
  jump_environment = [{
    name  = "CASED_SHELL_HOST_FILE"
    value = "/opt/cased/tmp/jump.json"
  }]

  jump_mount_point = {
    sourceVolume  = "scratch"
    containerPath = "/opt/cased/tmp"
  }
}