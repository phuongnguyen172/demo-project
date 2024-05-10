variable "role_name" {
  type = string
}

variable "role_assume_policy" {
  type = string
}

variable "policy_arns" {
  type = list(string)
}

variable "create_instance_profile" {
  type    = bool
  default = false
}

variable "instance_profile_name" {
  type    = string
  default = null
}
