variable "domain_name" {
  type        = string
  description = "Tên miền chính"
}
variable "alb_dns_name" {
  type        = string
  description = "DNS name của ALB"
}
variable "alb_zone_id" {
  type        = string
  description = "Zone ID của ALB"
}