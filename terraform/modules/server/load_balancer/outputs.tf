output "load_balancer_arn" {
  value       = aws_lb.load_balancer.arn
  description = "ARN of load balancer"
}

output "load_balancer_dns_name" {
  value       = aws_lb.load_balancer.dns_name
  description = "DNS Name of load balancer"
}

output "target_group_arn" {
  value       = aws_lb_target_group.target_group.arn
  description = "ARN of target group"
}
