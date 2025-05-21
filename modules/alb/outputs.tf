output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "dns_name" {
  value = aws_lb.this.dns_name
}

output "zone_id" {
  value = aws_lb.this.zone_id
}

output "target_group_arns" {
  value = { for k, v in aws_lb_target_group.tg : k => v.arn }
}