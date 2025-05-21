output "log_group_names" {
  description = "Tên các CloudWatch Log Group"
  value       = [for lg in aws_cloudwatch_log_group.ecs : lg.name]
}