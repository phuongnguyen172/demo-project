variable "autoscaling_group_name" {
  type = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet ids for autoscaling group"
}

variable "target_group_arns" {
  type        = list(string)
  description = "List of target group arns for autoscaling group"
}

variable "max_size" {
  type        = number
  description = "Maximum size of autoscaling group"
}

variable "min_size" {
  type        = number
  description = "Minimum size of autoscaling group"
}

variable "autoscaling_group_tags" {
  description = "Tags of autoscaling group when launch instances"
}

variable "image_id" {
  type        = string
  description = "Image ID of launch template"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Instance type of launch template"
}

variable "instance_profile" {
  type        = string
  description = "Instance profile of launch template"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group ids of launch template"
}

variable "user_data" {
  type        = string
  default     = null
  description = "User data of launch template"
}
