output "instance_profile_name" {
  value       = var.create_instance_profile ? aws_iam_instance_profile.instance_profile[0].name : null
  description = "instance profile name of the role"
}
