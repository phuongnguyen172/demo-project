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

module "networking_vpc" {
  source         = "bitbucket.org/phuongnguyen17/terraform-modules.networking.vpc"
  vpc_name       = "VPC-QC"
  vpc_cidr_block = "10.0.0.0/16"

  private_subnet_name = "PrivateSubnet"
  private_cidr_block  = ["10.0.1.0/24", "10.0.2.0/24"]

  public_subnet_name = "PublicSubnet"
  public_cidr_block  = ["10.0.3.0/24", "10.0.4.0/24"]

  internet_gateway_name = "InternetGateway-QC"
  nat_gateway_name      = "NATGateway-QC"

  env = "qc"
}
