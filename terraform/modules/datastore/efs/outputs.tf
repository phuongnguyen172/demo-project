output "dns_name" {
  value       = aws_efs_file_system.efs.dns_name
  description = "DNS Name of EFS"
}
