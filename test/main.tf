
terraform {
  required_providers {
    aws = ">= 3.35"
  }
  required_version = ">= 0.12"
}

provider "aws" {
  region  = "us-east-1"
  version = "~> 3.35"
}

module "test-minimal" {
  source = "../" # for local dev

  vpc_id                 = "1234"
  env                    = "test"
  cluster_id             = "1234"
  image                  = "casedhub/shell:unstable"
  security_group_ids     = []
  container_subnet_ids   = []
  nlb_subnet_ids         = []
  cased_shell_secret_arn = ""
  ssh_username           = "user"
  log_level              = "debug"
  hostname               = "test-minimal.example.com"
  zone_id                = "1234"
}

module "test-custom-health-check" {
  source = "../" # for local dev

  vpc_id                 = "1234"
  env                    = "test"
  cluster_id             = "1234"
  image                  = "casedhub/shell:unstable"
  security_group_ids     = []
  container_subnet_ids   = []
  nlb_subnet_ids         = []
  cased_shell_secret_arn = ""
  ssh_username           = "user"
  log_level              = "debug"
  hostname               = "test-minimal.example.com"
  zone_id                = "1234"

  http_health_check = [{
    protocol            = "TCP"
    port                = "80"
    path                = null
    matcher             = null
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 10
  }]

  https_health_check = [{
    protocol            = "TCP"
    port                = "80"
    path                = null
    matcher             = null
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 10
  }]
}

module "test-deprecated-autodiscovery" {
  source = "../" # for local dev

  vpc_id                             = "1234"
  env                                = "test"
  cluster_id                         = "1234"
  image                              = "casedhub/shell:unstable"
  security_group_ids                 = []
  container_subnet_ids               = []
  nlb_subnet_ids                     = []
  cased_shell_secret_arn             = ""
  ssh_username                       = "user"
  log_level                          = "debug"
  hostname                           = "test-minimal.example.com"
  zone_id                            = "1234"
  host_autodiscovery                 = true
  host_autodiscovery_descriptive_tag = "aws:autoscaling:groupName"
  host_autodiscovery_tag_filters = [{
    name = "environment"
    values = [
      "*test*"
    ]
  }]
}

module "test-jump-examples" {
  source = "../" # for local dev

  vpc_id                 = "1234"
  env                    = "test"
  cluster_id             = "1234"
  image                  = "casedhub/shell:unstable"
  security_group_ids     = []
  container_subnet_ids   = []
  nlb_subnet_ids         = []
  cased_shell_secret_arn = ""
  ssh_username           = "user"
  log_level              = "debug"
  hostname               = "test-minimal.example.com"
  zone_id                = "1234"
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
        cluster    = "test-cluster"
        task-group = "test-service"
      }
      limit     = 1
      sortBy    = "startedAt"
      sortOrder = "desc"
      prompt = {
        name         = "Test Rails Console"
        description  = "Use to perform exploratory debugging on the test cluster"
        shellCommand = "./bin/rails console"
        labels = {
          environment = "test"
        }
      }
    },
    {
      provider = "static"
      prompt = {
        description  = "Static entries can be added using the static provider"
        hostname     = "example.com"
        ipAddress    = "192.0.2.1"
        port         = "2222"
        username     = "example"
        promptForKey = true
      }
    }
  ]

}
