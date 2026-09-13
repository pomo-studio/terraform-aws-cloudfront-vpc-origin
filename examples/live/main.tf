terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 7.0"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "name" {
  description = "Prefix for the acceptance resources"
  type        = string
  default     = "acceptance"
}

variable "region" {
  description = "AWS region for the acceptance run"
  type        = string
  default     = "us-east-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  prefix = substr(var.name, 0, 24)

  tags = {
    ManagedBy   = "module-acceptance"
    AutoDestroy = "true"
  }
}

resource "aws_vpc" "this" {
  cidr_block           = "10.42.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = local.tags
}

# CloudFront VPC origins require an internet gateway on the VPC.
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = local.tags
}

resource "aws_subnet" "this" {
  count = 2

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = local.tags
}

resource "aws_security_group" "alb" {
  name_prefix = "${local.prefix}-alb-"
  description = "Acceptance load balancer ingress"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "HTTP from inside the VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "this" {
  name               = local.prefix
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.this[*].id

  tags = local.tags
}

resource "aws_lb_target_group" "this" {
  name     = local.prefix
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id

  tags = local.tags
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

module "vpc_origin" {
  source = "../../"

  name       = local.prefix
  origin_arn = aws_lb.this.arn

  tags = local.tags
}

output "vpc_origin_id" {
  description = "ID of the created VPC origin"
  value       = module.vpc_origin.id
}

output "vpc_origin_arn" {
  description = "ARN of the created VPC origin"
  value       = module.vpc_origin.arn
}
