# VPC origin basics

Create one CloudFront VPC origin from an existing load balancer ARN.

## What it creates

- A single `aws_cloudfront_vpc_origin` named `orders-blue`.
- It points at the supplied `origin_arn` and keeps the default HTTP/HTTPS ports and SSL protocols.

## Before you start

- Provider `hashicorp/aws` with credentials for the target account.
- Uses a local source, `../../`.
- The load balancer in `origin_arn` must already exist. The ARN in the example is a placeholder, so replace it or `plan` will not match real infrastructure.

## Run it

```bash
terraform init
terraform plan
terraform apply
```

## Clean up

```bash
terraform destroy
```
