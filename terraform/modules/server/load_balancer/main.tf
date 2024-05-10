resource "aws_lb" "load_balancer" {
  load_balancer_type = var.load_balancer_type
  name               = "LB-${var.load_balancer_name}"
  internal           = var.internal
  subnets            = var.subnet_ids
  security_groups    = var.security_group_ids
}


resource "aws_lb_target_group" "target_group" {
  name        = "TG-${var.target_group_name}"
  target_type = var.target_type
  vpc_id      = var.vpc_id
  port        = var.port
  protocol    = var.protocol

  health_check {
    path                = var.health_check_path
    port                = var.port
    protocol            = var.protocol
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    matcher             = var.health_check_matcher
  }
}
