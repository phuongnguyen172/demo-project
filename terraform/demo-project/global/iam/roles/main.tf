terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Region    = "global"
      Terraform = "true"
    }
  }
}

module "iam_role_Jenkins" {
  source = "../../../../modules/iam/role"

  role_name               = "Role_Jenkins"
  instance_profile_name   = "Profile_Jenkins"
  create_instance_profile = true
  role_assume_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

module "iam_role_KubernetesMaster" {
  source = "../../../../modules/iam/role"

  role_name               = "Role_KubernetesMaster"
  instance_profile_name   = "Profile_KubernetesMaster"
  create_instance_profile = true
  role_assume_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

module "iam_role_KubernetesWorker" {
  source = "../../../../modules/iam/role"

  role_name               = "Role_KubernetesWorker"
  instance_profile_name   = "Profile_KubernetesWorker"
  create_instance_profile = true
  role_assume_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}
