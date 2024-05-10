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

data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

data "terraform_remote_state" "security_groups" {
  backend = "local"

  config = {
    path = "/home/phuongnguyen/D/!Poeta/Study/Infrastructure/terraform/projects/demo/mgmt/networking/security_groups/terraform.tfstate"
  }
}

module "datastore_efs_Jenkins" {
  source = "bitbucket.org/phuongnguyen17/terraform-modules.datastore.efs"

  efs_name           = "EFS_Jenkins"
  subnet_ids         = data.aws_subnets.default_subnets.ids
  security_group_ids = [data.terraform_remote_state.security_groups.outputs.SG_EFS_Jenkins_id]  
}
