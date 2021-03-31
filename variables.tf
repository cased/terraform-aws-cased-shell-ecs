variable "vpc_id" {
  type        = string
  description = "The id of the VPC for the NLB and the VPC."
}

variable "env" {
  type        = string
  description = "The environment you will use. This is used to preface various names."
}

variable "cluster_id" {
  type        = string
  description = "The id of the ECS cluster where the service will be deployed."
}

variable "security_group_ids" {
  type        = list(string)
  description = "A list of security group ids that will be used for the container."
}

variable "container_subnet_ids" {
  type        = list(string)
  description = "A list of subnet ids that will be used for the container."
}

variable "nlb_subnet_ids" {
  type        = list(string)
  description = "A list of subnet ids that will be used for the NLB."
}

variable "cased_shell_secret_arn" {
  type        = string
  description = "The ARN of a secret used for the CASED_SHELL_SECRET env variable"
}

variable "ssh_key_arn" {
  type        = string
  description = "The ARN of a secret used for the CASED_SHELL_SSH_PRIVATE_KEY env variable"
  default     = null
}

variable "ssh_passphrase_arn" {
  type        = string
  description = "The string passphrase used for the CASED_SHELL_SSH_PASSPHRASE env variable"
  default     = null
}

variable "ssh_username" {
  type        = string
  description = "The string username used for the CASED_SHELL_SSH_USERNAME env variable"
  default     = null
}

variable "hostname" {
  type        = string
  description = "The hostname of the Cased Shell deployment, without protocol (e.g., 'webshell.example.com')"
}

variable "zone_id" {
  type        = string
  description = "The Route53 apex zone id which will be associated with the hostname entry"
}

variable "grace_period" {
  type        = number
  description = "Startup grace period, or the duration of time the application is expected to fail health checks on startup"
  default     = 360
}

variable "memory" {
  type        = number
  default     = 1024
  description = "The memory in MB allocated to the container"
}

variable "cpu" {
  type        = number
  default     = 180
  description = "The CPU allocated to the container"
}

variable "image" {
  type        = string
  default     = "casedhub/shell:latest"
  description = "The container image to use"
}

variable "log_level" {
  type        = string
  default     = "error"
  description = "Log level"
}

variable "health_check_enabled" {
  type    = bool
  default = true
}

variable "http_health_check_enabled" {
  type    = bool
  default = true
}

variable "https_health_check_enabled" {
  type    = bool
  default = true
}

variable "health_check_healthy_threshold" {
  type    = string
  default = "2"
}

variable "http_health_check_healthy_threshold" {
  type    = string
  default = ""
}

variable "https_health_check_healthy_threshold" {
  type    = string
  default = ""
}
variable "health_check_unhealthy_threshold" {
  type    = string
  default = "2"
}

variable "http_health_check_unhealthy_threshold" {
  type    = string
  default = ""
}

variable "https_health_check_unhealthy_threshold" {
  type    = string
  default = ""
}
variable "health_check_matcher" {
  type    = string
  default = ""
}

variable "http_health_check_matcher" {
  type    = string
  default = "200-399"
}

variable "https_health_check_matcher" {
  type    = string
  default = "200-399"
}
variable "health_check_path" {
  type    = string
  default = "/_health"
}

variable "http_health_check_path" {
  type    = string
  default = ""
}

variable "https_health_check_path" {
  type    = string
  default = ""
}
variable "health_check_port" {
  type    = string
  default = "traffic-port"
}

variable "http_health_check_port" {
  type    = string
  default = ""
}

variable "https_health_check_port" {
  type    = string
  default = ""
}
variable "health_check_protocol" {
  type    = string
  default = "TCP"
}

variable "http_health_check_protocol" {
  type    = string
  default = "HTTP"
}

variable "https_health_check_protocol" {
  type    = string
  default = "HTTPS"
}
variable "health_check_interval" {
  type    = string
  default = "10"
}
variable "http_health_check_interval" {
  type    = string
  default = ""
}

variable "https_health_check_interval" {
  type    = string
  default = ""
}
