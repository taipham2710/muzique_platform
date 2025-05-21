variable "domain_name" {
  type        = string
  description = "Domain cần cấp SSL"
}
variable "zone_id" {
  type        = string
  description = "ID của Route53 Hosted Zone"
}