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

locals {
  any_port     = 0
  any_protocol = "-1"
  vpc_ips      = ["172.31.0.0/16"]
  all_ips      = ["0.0.0.0/0"]
}

data "aws_vpc" "default_vpc" {
  default = true
}

resource "aws_security_group" "SG_Jenkins" {
  name   = "SG_Jenkins"
  vpc_id = data.aws_vpc.default_vpc.id

  ingress {
    description = "Allow access to Jenkins port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = local.all_ips
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = local.all_ips
  }

  egress {
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips
  }
}

resource "aws_security_group" "SG_KubernetesMaster" {
  name   = "SG_KubernetesMaster"
  vpc_id = data.aws_vpc.default_vpc.id

  ingress {
    description = "Kubernetes API server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = local.all_ips
  }

  ingress {
    description = "etcd server client API"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = local.vpc_ips
  }

  ingress {
    description = "Kubelet API"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = local.vpc_ips
  }

  ingress {
    description = "kube-controller-manager"
    from_port   = 10257
    to_port     = 10257
    protocol    = "tcp"
    cidr_blocks = local.vpc_ips
  }

  ingress {
    description = "kube-scheduler"
    from_port   = 10259
    to_port     = 10259
    protocol    = "tcp"
    cidr_blocks = local.vpc_ips
  }

  ingress {
    description = "NodePort Services"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = local.all_ips
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = local.all_ips
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = local.all_ips
  }

  ingress {
    description = "Cilium VXLAN overlay mode"
    from_port   = 8472
    to_port     = 8472
    protocol    = "UDP"
    cidr_blocks = local.vpc_ips
  }

  egress {
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips
  }
}

resource "aws_security_group" "SG_KubernetesWorker" {
  name   = "SG_KubernetesWorker"
  vpc_id = data.aws_vpc.default_vpc.id

  ingress {
    description = "NodePort Services"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = local.all_ips
  }

  ingress {
    description = "Kubelet API"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = local.vpc_ips
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.all_ips
  }

  ingress {
    description = "Cilium VXLAN overlay mode"
    from_port   = 8472
    to_port     = 8472
    protocol    = "UDP"
    cidr_blocks = local.vpc_ips
  }

  egress {
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips
  }
}
