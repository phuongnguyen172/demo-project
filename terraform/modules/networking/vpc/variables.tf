variable "vpc_name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "private_subnet_name" {
  type = string
}

variable "private_cidr_block" {
  type = list(string)
}

variable "public_subnet_name" {
  type = string
}

variable "public_cidr_block" {
  type = list(string)
}

variable "internet_gateway_name" {
  type = string
}

variable "nat_gateway_name" {
  type = string
}

variable "env" {
  type = string
}
