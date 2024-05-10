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
      Region    = "us-east-1"
      Terraform = "true"
    }
  }
}

data "aws_route53_zone" "poeta_click" {
  name = "poeta.click"
}

resource "aws_acm_certificate" "poeta_click_certificate" {
  domain_name       = "*.poeta.click"
  validation_method = "DNS"
}

resource "aws_route53_record" "poeta_click_validation_record" {
  zone_id = data.aws_route53_zone.poeta_click.id
  type    = tolist(aws_acm_certificate.poeta_click_certificate.domain_validation_options)[0].resource_record_type
  name    = tolist(aws_acm_certificate.poeta_click_certificate.domain_validation_options)[0].resource_record_name
  records = [tolist(aws_acm_certificate.poeta_click_certificate.domain_validation_options)[0].resource_record_value]
  ttl     = 600
}

resource "aws_acm_certificate_validation" "poeta_click_validation" {
  certificate_arn         = aws_acm_certificate.poeta_click_certificate.arn
  validation_record_fqdns = [aws_route53_record.poeta_click_validation_record.fqdn]
}
