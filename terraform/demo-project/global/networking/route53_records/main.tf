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
}

data "aws_route53_zone" "poeta_click" {
  name = "poeta.click"
}

data "terraform_remote_state" "elastic_ips" {
  backend = "local"

  config = {
    path = "/home/phuongnguyen/D/!Poeta/Study/Infrastructure/terraform/projects/demo/mgmt/networking/elastic_ips/terraform.tfstate"
  }
}

data "aws_lb" "k8s_load_balancer" {
  name = "LB-Kubernetes"
}

resource "aws_route53_record" "jenkins" {
  zone_id = data.aws_route53_zone.poeta_click.id
  type    = "A"
  name    = "jenkins"
  records = [data.terraform_remote_state.elastic_ips.outputs.eip_Jenkins_public_ip]
  ttl     = 600
}

resource "aws_route53_record" "goal" {
  zone_id = data.aws_route53_zone.poeta_click.id
  type = "CNAME"
  name = "goal"
  records = [data.aws_lb.k8s_load_balancer.dns_name]
  ttl = 600
}

resource "aws_route53_record" "tkb" {
  zone_id = data.aws_route53_zone.poeta_click.id
  type = "CNAME"
  name = "tkb"
  records = [data.aws_lb.k8s_load_balancer.dns_name]
  ttl = 600
}