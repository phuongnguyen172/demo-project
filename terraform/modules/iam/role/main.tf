resource "aws_iam_role" "role" {
  name               = var.role_name
  assume_role_policy = var.role_assume_policy
}

resource "aws_iam_role_policy_attachment" "role_policy" {
  role = aws_iam_role.role.name

  for_each   = toset(var.policy_arns)
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "instance_profile" {
  count = var.create_instance_profile ? 1 : 0

  name = var.instance_profile_name
  role = aws_iam_role.role.name
}
