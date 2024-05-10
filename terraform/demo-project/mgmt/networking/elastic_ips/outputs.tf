output "eip_Jenkins_allocation_id" {
  value       = aws_eip.eip_Jenkins.allocation_id
  description = "Allocation ID of eip_Jenkins"
}

output "eip_Jenkins_public_ip" {
  value       = aws_eip.eip_Jenkins.public_ip
  description = "Public IP of eip_Jenkins"
}

output "eip_KubernetesMaster_allocation_id" {
  value       = aws_eip.eip_KubernetesMaster.allocation_id
  description = "Allocation ID of eip_KubernetesMaster"
}