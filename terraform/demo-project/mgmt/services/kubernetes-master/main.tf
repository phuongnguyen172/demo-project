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

data "terraform_remote_state" "elastic_ips" {
  backend = "local"

  config = {
    path = "/home/phuongnguyen/D/!Poeta/Study/Infrastructure/terraform/projects/demo/mgmt/networking/elastic_ips/terraform.tfstate"
  }
}

data "terraform_remote_state" "certificate" {
  backend = "local"

  config = {
    path = "/home/phuongnguyen/D/!Poeta/Study/Infrastructure/terraform/projects/demo/global/security/certificates/terraform.tfstate"
  }
}

module "server_ec2_instance" {
  source = "bitbucket.org/phuongnguyen17/terraform-modules.server.ec2_instance"

  ami_id = data.aws_ami.ami_Ubuntu22.id
  instance_name = "KubernetesMaster"
  instance_type = "t3a.small"
  instance_profile = data.terraform_remote_state.roles.outputs.KubernetesMasterRole_instance_profile
  security_group_ids = [data.terraform_remote_state.security_groups.outputs.SG_Kubernetes_Master_id]
  subnet_id = "subnet-00d70552010a00c41"
  private_ip = "172.31.16.12"
  key_name = "Demo"
  volume_size = 20
  volume_type = "gp2"
}

resource "aws_eip_association" "eip_assoc_KubernetesMaster" {
  instance_id = module.server_ec2_instance.instance_id
  allocation_id = data.terraform_remote_state.elastic_ips.outputs.eip_KubernetesMaster_allocation_id
}

module "server_load_balancer" {
  source = "bitbucket.org/phuongnguyen17/terraform-modules.server.load_balancer"

  load_balancer_type = "application"
  load_balancer_name = "Kubernetes"
  subnet_ids = ["subnet-00d70552010a00c41", "subnet-0c612b8998a4048a0"]
  security_group_ids = [data.terraform_remote_state.security_groups.outputs.SG_LB_Kubernetes_id]

  target_group_name = "Kubernetes"
  target_type = "instance"
  vpc_id = data.aws_vpc.default_vpc.id
  port = 80
  protocol = "HTTP"
  health_check_path = "/"
  health_check_interval = 10
  health_check_timeout = 5
  health_check_healthy_threshold = 3
  health_check_unhealthy_threshold = 5 
  health_check_matcher = 200
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = module.server_load_balancer.load_balancer_arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn = data.terraform_remote_state.certificate.outputs.acm_certificate_arn

  default_action {
    type = "forward"
    target_group_arn = module.server_load_balancer.target_group_arn
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  target_group_arn = module.server_load_balancer.target_group_arn
  target_id = module.server_ec2_instance.instance_id
}