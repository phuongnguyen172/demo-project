output "id" {
  value       = module.networking_vpc.id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value       = module.networking_vpc.public_subnet_ids
  description = "The IDs of the public subnets"
}

output "private_subnet_ids" {
  value       = module.networking_vpc.private_subnet_ids
  description = "The IDs of the private subnets"
}
