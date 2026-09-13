# terraform-aws-cloudfront-vpc-origin

[![Terraform Validation](https://github.com/pomo-studio/terraform-aws-cloudfront-vpc-origin/actions/workflows/terraform.yml/badge.svg)](https://github.com/pomo-studio/terraform-aws-cloudfront-vpc-origin/actions/workflows/terraform.yml)
[![Terraform Registry](https://img.shields.io/badge/terraform-registry-844FBA?logo=terraform)](https://registry.terraform.io/modules/pomo-studio/cloudfront-vpc-origin/aws)

[Changelog](CHANGELOG.md)

Let CloudFront reach an application that lives inside a VPC, without giving the application a public address. The module wraps a CloudFront VPC origin, the resource that connects a distribution to a private load balancer or endpoint.

> **Status:** work in progress. The interface is still moving and should be treated as unstable until the first tagged release.

## When to use it

Reach for this module when the origin already exists behind an internal load balancer or VPC endpoint and you want CloudFront, not the internet, to be the only way in. It creates the CloudFront side of that connection and nothing else.

Use a different tool when you also need the distribution (that is [`pomo-studio/cloudfront-frontdoor/aws`](https://registry.terraform.io/modules/pomo-studio/cloudfront-frontdoor/aws)), or when the origin is already public.

## Quickstart

```hcl
module "app_origin" {
  source  = "pomo-studio/cloudfront-vpc-origin/aws"
  version = "~> 0.1"

  name       = "orders-blue"
  origin_arn = aws_lb.orders.arn

  tags = { Environment = "production" }
}
```

## Design decisions

- **One origin, one VPC origin.** Each deployment colour gets its own VPC origin so traffic can shift between them without replacing the connection.
- **The caller owns the load balancer.** The module takes an existing ARN, so the network and the compute stay with the team that runs them.
- **Explicit protocol policy.** `origin_protocol_policy` has no silent default in the network path; it defaults to `https-only` and is validated.

## Examples

- [Basic](examples/basic/): one VPC origin pointed at a load balancer ARN.

## Reference

<details>
<summary>Reference</summary>

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0, < 7.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_vpc_origin.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_vpc_origin) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_http_port"></a> [http\_port](#input\_http\_port) | HTTP port CloudFront uses to reach the origin | `number` | `80` | no |
| <a name="input_https_port"></a> [https\_port](#input\_https\_port) | HTTPS port CloudFront uses to reach the origin | `number` | `443` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the VPC origin | `string` | n/a | yes |
| <a name="input_origin_arn"></a> [origin\_arn](#input\_origin\_arn) | ARN of the private origin endpoint, such as an internal Application Load Balancer or Network Load Balancer | `string` | n/a | yes |
| <a name="input_origin_protocol_policy"></a> [origin\_protocol\_policy](#input\_origin\_protocol\_policy) | Protocol CloudFront uses to reach the origin (http-only, match-viewer, or https-only) | `string` | `"https-only"` | no |
| <a name="input_origin_ssl_protocols"></a> [origin\_ssl\_protocols](#input\_origin\_ssl\_protocols) | TLS protocols CloudFront uses to negotiate with the origin | `list(string)` | <pre>[<br/>  "TLSv1.2"<br/>]</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the VPC origin | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the VPC origin, used as the origin in a CloudFront distribution |
| <a name="output_id"></a> [id](#output\_id) | ID of the VPC origin |
<!-- END_TF_DOCS -->

</details>

## Support and license

Part of the [pomo-studio](https://github.com/pomo-studio) Terraform modules, run in production by [postmodern.](https://pomo.studio). Regenerate the reference with `terraform-docs` v0.20.0 (`terraform-docs .`); CI fails on drift.

See the [contribution guide](https://github.com/pomo-studio/.github/blob/main/CONTRIBUTING.md) and [security policy](https://github.com/pomo-studio/.github/blob/main/SECURITY.md).

MIT licensed. See [LICENSE](LICENSE).
