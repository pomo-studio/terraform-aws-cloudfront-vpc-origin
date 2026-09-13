# Offline plan tests for terraform-aws-cloudfront-vpc-origin.
#
# mock_provider keeps these running with no AWS credentials, so they gate every
# pull request. They pin the interface: the default protocol policy, the name,
# and the validation that rejects anything else. The live acceptance workflow
# proves the same configuration against real AWS.

mock_provider "aws" {}

variables {
  name       = "acceptance"
  origin_arn = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/acceptance/50dc6c495c0c9188"
}

run "plans_an_https_only_origin" {
  command = plan

  assert {
    condition     = aws_cloudfront_vpc_origin.this.vpc_origin_endpoint_config[0].name == "acceptance"
    error_message = "The VPC origin should take the given name."
  }

  assert {
    condition     = aws_cloudfront_vpc_origin.this.vpc_origin_endpoint_config[0].origin_protocol_policy == "https-only"
    error_message = "The origin should default to https-only."
  }
}

run "rejects_an_unknown_protocol_policy" {
  command = plan

  variables {
    origin_protocol_policy = "tls-only"
  }

  expect_failures = [var.origin_protocol_policy]
}
