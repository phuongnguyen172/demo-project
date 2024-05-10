resource "aws_autoscaling_group" "asg" {
  name                = "ASG-${var.autoscaling_group_name}"
  vpc_zone_identifier = var.subnet_ids
  target_group_arns = var.target_group_arns

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  max_size = var.max_size
  min_size = var.min_size

  dynamic "tag" {
    for_each = var.autoscaling_group_tags
    content {
      key                 = tag.value.key
      value               = tag.value.value
      propagate_at_launch = tag.value.propagate_at_launch
    }
  }
}

resource "aws_launch_template" "launch_template" {
  name_prefix            = "ASG-${var.autoscaling_group_name}"
  image_id               = var.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_group_ids

  iam_instance_profile {
    name = var.instance_profile
  }

  user_data = var.user_data
}
