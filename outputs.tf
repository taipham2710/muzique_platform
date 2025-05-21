output "alb_dns_name" {
  value       = module.alb.dns_name
  description = "DNS name của Application Load Balancer"
}

output "alb_zone_id" {
  value       = module.alb.zone_id
  description = "Zone ID của ALB"
}

output "ecr_repositories" {
  value       = module.ecr.repositories
  description = "ECR repo URLs cho từng service"
}

output "route53_zone_id" {
  value       = module.route53.zone_id
  description = "Route53 zone id"
}

output "cloudwatch_log_groups" {
  value       = module.logs.log_group_names
  description = "Tên log group CloudWatch cho từng service"
}