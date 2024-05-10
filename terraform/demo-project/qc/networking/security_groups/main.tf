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
}

locals {
  any_port     = -1
  any_protocol = "-1"
  all_ips      = ["0.0.0.0/0"]
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "/home/phuongnguyen/D/!Poeta/Study/Terraform/demo/qc/networking/vpc/terraform.tfstate"
  }
}

module "networking_security_group_Jenkins" {
  source = "bitbucket.org/phuongnguyen17/terraform-modules.networking.security_group"

  security_group_name = "Jenkins"
  vpc_id              = data.terraform_remote_state.vpc.outputs.id

  env = "qc"
}

resource "aws_security_group_rule" "Jenkins_ingress_8080" {
  type              = "ingress"
  security_group_id = module.networking_security_group_Jenkins.id
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "Jenkins_egress_all" {
  type              = "egress"
  security_group_id = module.networking_security_group_Jenkins.id
  from_port         = local.any_port
  to_port           = local.any_port
  protocol          = local.any_protocol
  cidr_blocks       = local.all_ips
}
