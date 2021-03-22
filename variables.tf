variable "vpc_id" {
  type        = string
  description = "The id of the VPC for the NLB and the VPC."
}

variable "env" {
  type        = string
  description = "The environment you will use. Used to preface various names."
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

variable "hostname" {
  type        = string
  description = "The hostname of the Cased Shell deployment, without protocol (e.g., 'webshell.example.com')"
}

variable "zone_id" {
  type        = string
  description = "The Route53 zone id which will be associated with the hostname entry"
}

variable "grace_period" {
  type        = number
  description = "The service startup grace period. We want this to be essentially infinite."
  default     = 2147483647
}

variable "memory" {
  type        = number
  default     = 1026
  description = "The memory allocated to the container"
}

variable "cpu" {
  type        = number
  default     = 180
  description = "The CPU allocated to the container"
}