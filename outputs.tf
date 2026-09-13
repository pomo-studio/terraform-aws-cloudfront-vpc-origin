output "id" {
  description = "ID of the VPC origin"
  value       = aws_cloudfront_vpc_origin.this.id
}

output "arn" {
  description = "ARN of the VPC origin, used as the origin in a CloudFront distribution"
  value       = aws_cloudfront_vpc_origin.this.arn
}
