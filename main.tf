terraform {
  required_version = ">= 0.12"
}


######## ECS Service for Cased Shell ##########################################

# The service that runs Cased Shell
resource "aws_ecs_service" "service" {
  name                               = local.base_name
  cluster                            = var.cluster_id
  task_definition                    = aws_ecs_task_definition.definition.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 200
  scheduling_strategy                = "REPLICA"
  health_check_grace_period_seconds  = var.grace_period

  network_configuration {
    subnets         = var.container_subnet_ids
    security_groups = var.security_group_ids
  }

  # Here we connect to the NLB via the target groups that are specified
  load_balancer {
    target_group_arn = aws_lb_target_group.cased-shell-target-80.arn
    container_port   = 80
    container_name   = local.base_name
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.cased-shell-target-443.arn
    container_port   = 443
    container_name   = local.base_name
  }

  depends_on = [
    aws_lb_target_group.cased-shell-target-80,
    aws_lb_target_group.cased-shell-target-443
  ]
}

# The task definition used for Cased Shell
resource "aws_ecs_task_definition" "definition" {
  family = "${var.env}-cased-shell-service-definition"

  container_definitions = <<EOF
    [
     ${module.cased-shell-container-definition.json_map}
    ]
  EOF

  network_mode       = "awsvpc"
  execution_role_arn = aws_iam_role.ecs-task-execution-role.arn
}

# The container definition used for Cased Shell
module "cased-shell-container-definition" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.21.0"

  container_name               = local.base_name
  container_image              = "casedhub/shell:latest"
  container_memory             = var.memory
  container_memory_reservation = floor(var.memory / 3)
  container_cpu                = var.cpu
  environment                  = concat(local.environment, var.ssh_username == null ? [] : [local.username])

  # Concat these as secrets if their valueFrom/value is set
  secrets = concat([local.shell_secret_string], var.ssh_key_arn == null ? [] : [local.private_key], var.ssh_passphrase_arn == null ? [] : [local.passphrase])

  port_mappings = [
    {
      hostPort      = 443
      containerPort = 443
      protocol      = "tcp"
    },
    {
      hostPort      = 80
      containerPort = 80
      protocol      = "tcp"
    },
  ]
}

locals {

  base_name = "${var.env}-cased-shell"

  environment = [
    {
      name  = "CASED_SHELL_HOSTNAME"
      value = var.hostname
    },
  ]

  username = {
    name  = "CASED_SHELL_SSH_USERNAME"
    value = var.ssh_username
  }

  shell_secret_string = {
    name      = "CASED_SHELL_SECRET"
    valueFrom = var.cased_shell_secret_arn
  }

  private_key = {
    name      = "CASED_SHELL_SSH_PRIVATE_KEY"
    valueFrom = var.ssh_key_arn
  }

  passphrase = {
    name      = "CASED_SHELL_SSH_PASSPHRASE"
    valueFrom = var.ssh_passphrase_arn
  }
}


######## IAM policies and roles for Cased Shell ###############################


# Allow a role to read secrets from SSM, secrets manager, and use KMS
data "aws_iam_policy_document" "read-secrets" {
  statement {
    actions = [
      "ssm:GetParameters",
      "secretsmanager:GetSecretValue",
      "kms:Decrypt"
    ]

    resources = [
      "arn:aws:ssm:*",
      "arn:aws:secretsmanager:*",
      "arn:aws:kms:*",
    ]
  }
}

# Allow ECS to assume role for task execution
data "aws_iam_policy_document" "ecs-tasks-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


# ECS Task Execution Role is associated with a task definition,
# and represents the permissions for the Docker container itself.

# The role itself
resource "aws_iam_role" "ecs-task-execution-role" {
  name               = "ecs-task-exec-role-${local.base_name}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-tasks-policy.json
}

# Add the read-secrets policy to the ecs task execution role
resource "aws_iam_role_policy" "read-secrets-policy" {
  policy = data.aws_iam_policy_document.read-secrets.json
  role   = aws_iam_role.ecs-task-execution-role.id
}

# Attach the general ECS Task execution role policy to the ecs task execution role
resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs-task-execution-role.name
}


######## Network Load Balancer for Cased Shell ################################

# The Cased Shell NLB forwards IP traffic on 80 and 443 to targets on those
# same ports.

resource "aws_lb" "cased-shell-nlb" {
  name               = "${local.base_name}-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.nlb_subnet_ids
}

resource "aws_lb_listener" "cased-shell-listener-80" {
  load_balancer_arn = aws_lb.cased-shell-nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cased-shell-target-80.arn
  }
}

resource "aws_lb_listener" "cased-shell-listener-443" {
  load_balancer_arn = aws_lb.cased-shell-nlb.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cased-shell-target-443.arn
  }
}

resource "aws_lb_target_group" "cased-shell-target-80" {
  name_prefix          = "t-cs8"
  port                 = 80
  target_type          = "ip"
  protocol             = "TCP"
  vpc_id               = var.vpc_id
  deregistration_delay = "5"
  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    matcher             = "200-399"
    path                = "/_health"
    port                = "traffic-port"
    protocol            = "HTTP"
    interval            = "10"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "cased-shell-target-443" {
  name_prefix          = "t-cs4"
  port                 = 443
  target_type          = "ip"
  protocol             = "TCP"
  vpc_id               = var.vpc_id
  deregistration_delay = "5"

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    matcher             = "200-399"
    path                = "/_health"
    port                = "traffic-port"
    protocol            = "HTTPS"
    interval            = "10"
  }

  lifecycle {
    create_before_destroy = true
  }
}


######## DNS and Route53 ######################################################

resource "aws_route53_record" "cased-shell" {
  zone_id = var.zone_id
  name    = var.hostname
  type    = "A"

  alias {
    name                   = aws_lb.cased-shell-nlb.dns_name
    zone_id                = aws_lb.cased-shell-nlb.zone_id
    evaluate_target_health = true
  }
}