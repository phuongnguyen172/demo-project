variable "load_balancer_type" {
  type = string
}

variable "load_balancer_name" {
  type = string
}

variable "internal" {
  type    = bool
  default = false
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}

variable "target_group_name" {
  type = string
}

variable "target_type" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "port" {
  type = number
}

variable "protocol" {
  type = string
}

variable "health_check_path" {
  type = string
}

variable "health_check_interval" {
  type = number
}

variable "health_check_timeout" {
  type = number
}

variable "health_check_healthy_threshold" {
  type = number
}

variable "health_check_unhealthy_threshold" {
  type = number
}

variable "health_check_matcher" {
  type = string
}
