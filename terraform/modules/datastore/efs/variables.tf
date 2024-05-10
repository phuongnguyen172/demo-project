variable "efs_name" {
  type = string
}

variable "performance_mode" {
  type    = string
  default = "generalPurpose"
}

variable "throughput_mode" {
  type    = string
  default = "bursting"
}

variable "encrypted" {
  type    = bool
  default = true
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for creating mount targets"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs for creating mount targets"
}