
terraform {
  required_providers {
    aws = "~> 2.54"
  }
  required_version = ">= 0.12"
}

provider "aws" {
  region  = "us-east-1"
  version = "~> 2.54"
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