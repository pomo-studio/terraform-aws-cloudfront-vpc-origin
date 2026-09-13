resource "aws_cloudfront_vpc_origin" "this" {
  vpc_origin_endpoint_config {
    name                   = var.name
    arn                    = var.origin_arn
    http_port              = var.http_port
    https_port             = var.https_port
    origin_protocol_policy = var.origin_protocol_policy

    origin_ssl_protocols {
      items    = var.origin_ssl_protocols
      quantity = length(var.origin_ssl_protocols)
    }
  }

  tags = var.tags
}
