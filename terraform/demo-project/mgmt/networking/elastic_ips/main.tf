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
  region = "us-east-1"
  default_tags {
    tags = {
      Project     = "demo"
      Environment = "mgmt"
      Terraform   = "true"
    }
  }
}

resource "aws_eip" "jenkins" {
  domain = "vpc"

  tags = {
    Name = "EIP_Jenkins"
  }
}

resource "aws_eip" "kubernetes_master" {
  domain = "vpc"

  tags = {
    Name = "EIP_KubernetesMaster"
  }
}
