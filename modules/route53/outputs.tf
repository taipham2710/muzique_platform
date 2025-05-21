output "zone_id" {
  value       = data.aws_route53_zone.main.zone_id
  description = "ID của Route53 Hosted Zone"
}