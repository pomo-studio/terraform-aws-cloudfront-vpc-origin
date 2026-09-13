variable "name" {
  description = "Name of the VPC origin"
  type        = string
}

variable "origin_arn" {
  description = "ARN of the private origin endpoint, such as an internal Application Load Balancer or Network Load Balancer"
  type        = string
}

variable "http_port" {
  description = "HTTP port CloudFront uses to reach the origin"
  type        = number
  default     = 80
}

variable "https_port" {
  description = "HTTPS port CloudFront uses to reach the origin"
  type        = number
  default     = 443
}

variable "origin_protocol_policy" {
  description = "Protocol CloudFront uses to reach the origin (http-only, match-viewer, or https-only)"
  type        = string
  default     = "https-only"

  validation {
    condition     = contains(["http-only", "match-viewer", "https-only"], var.origin_protocol_policy)
    error_message = "origin_protocol_policy must be one of: http-only, match-viewer, https-only."
  }
}

variable "origin_ssl_protocols" {
  description = "TLS protocols CloudFront uses to negotiate with the origin"
  type        = list(string)
  default     = ["TLSv1.2"]
}

variable "tags" {
  description = "Tags applied to the VPC origin"
  type        = map(string)
  default     = {}
}
