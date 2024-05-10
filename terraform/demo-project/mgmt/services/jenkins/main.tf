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

data "aws_ami" "ami_ubuntu_22" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_iam_instance_profile" "jenkins" {
  name = "Profile_Jenkins"
}

data "aws_security_group" "jenkins" {
  name = "SG_Jenkins"
}

data "terraform_remote_state" "elastic_ips" {
  backend = "local"

  config = {
    path = "/home/phuongnguyen/D/!Poeta/Study/Infrastructure/terraform/projects/demo/mgmt/networking/elastic_ips/terraform.tfstate"
  }
}


module "server_ec2_instance" {
  source = "bitbucket.org/phuongnguyen17/terraform-modules.server.ec2_instance"

  ami_id             = data.aws_ami.ami_Jenkins.id
  instance_name      = "Jenkins"
  instance_type      = "t3a.small"
  instance_profile   = data.aws_iam_instance_profile.jenkins.name
  security_group_ids = [data.aws_security_group.jenkins.id]
  subnet_id          = "subnet-00d70552010a00c41"
  private_ip         = "172.31.16.11"
}

resource "aws_eip_association" "eip_assoc_Jenkins" {
  instance_id   = module.server_ec2_instance.instance_id
  allocation_id = data.terraform_remote_state.elastic_ips.outputs.eip_Jenkins_allocation_id
}
