variable "ami_id" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_profile" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "private_ip" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "user_data" {
  type    = string
  default = ""
}

variable "volume_size" {
  type    = number
  default = 8
}

variable "volume_type" {
  type    = string
  default = "gp2"
}
