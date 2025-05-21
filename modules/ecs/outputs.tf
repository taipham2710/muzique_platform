output "cluster_id" {
  value       = aws_ecs_cluster.main.id
  description = "ECS Cluster ID"
}
output "service_names" {
  value       = [for k, v in aws_ecs_service.svc : v.name]
  description = "Tên các ECS service"
}
output "task_definition_arns" {
  value       = { for k, v in aws_ecs_task_definition.task : k => v.arn }
  description = "ARN các Task Definition"
}