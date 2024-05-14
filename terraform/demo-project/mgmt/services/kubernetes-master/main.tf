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

data "aws_iam_instance_profile" "kubernetes_master" {
  name = "Profile_KubernetesMaster"
}

data "aws_security_group" "kubernetes_master" {
  name = "SG_KubernetesMaster"
}

data "aws_eip" "kubernetes_master" {
  tags = {
    Name = "EIP_KubernetesMaster"
  }
}

module "ec2_instance_kubernetes_master" {
  source = "../../../../modules/server/ec2_instance"

  ami_id             = data.aws_ami.ami_ubuntu_22.id
  instance_name      = "KubernetesMaster"
  instance_type      = "t3a.small"
  instance_profile   = data.aws_iam_instance_profile.kubernetes_master.name
  security_group_ids = [data.aws_security_group.kubernetes_master.id]
  subnet_id          = "subnet-00d70552010a00c41"
  private_ip         = "172.31.16.12"
  key_name           = "Demo"
  volume_size        = 20
  volume_type        = "gp2"
}

resource "aws_eip_association" "eip_assoc_KubernetesMaster" {
  instance_id   = module.ec2_instance_kubernetes_master.instance_id
  allocation_id = data.aws_eip.kubernetes_master.id
}
