resource "aws_efs_file_system" "efs" {
  performance_mode = var.performance_mode
  throughput_mode  = var.throughput_mode
  encrypted        = var.encrypted
  tags = {
    Name = var.efs_name
  }
}

resource "aws_efs_mount_target" "efs_mount_target" {
  count = length(var.subnet_ids)

  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = var.security_group_ids
}
