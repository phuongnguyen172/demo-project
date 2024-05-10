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

data "aws_ami" "ami_Ubuntu22" {
  owners = ["099720109477"]
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

data "terraform_remote_state" "roles" {
  backend = "local"

  config = {
    path = "/home/phuongnguyen/D/!Poeta/Study/Infrastructure/terraform/projects/demo/global/iam/roles/terraform.tfstate"
  }
}

data "terraform_remote_state" "security_groups" {
  backend = "local"

  config = {
    path = "/home/phuongnguyen/D/!Poeta/Study/Infrastructure/terraform/projects/demo/mgmt/networking/security_groups/terraform.tfstate"
  }
}

module "server_ec2_instance" {
  source = "bitbucket.org/phuongnguyen17/terraform-modules.server.ec2_instance"

  ami_id = data.aws_ami.ami_Ubuntu22.id
  instance_name = "KubernetesMaster"
  instance_type = "t3a.small"
  instance_profile = data.terraform_remote_state.roles.outputs.KubernetesWorkerRole_instance_profile
  security_group_ids = [data.terraform_remote_state.security_groups.outputs.SG_Kubernetes_Worker_id]
  subnet_id = "subnet-00d70552010a00c41"
  private_ip = "172.31.16.21"
  key_name = "Demo"
  volume_size = 8
  volume_type = "gp2"
}