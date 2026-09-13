terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 7.0"
    }
  }
}

module "vpc_origin" {
  source = "../../"

  name       = "orders-blue"
  origin_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/orders-blue/50dc6c495c0c9188"

  tags = {
    Environment = "production"
  }
}
