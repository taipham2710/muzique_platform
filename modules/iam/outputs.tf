output "ecs_execution_role_arn" {
  value       = aws_iam_role.ecs_execution.arn
  description = "ARN của ECS execution role"
}
output "ecs_task_role_arn" {
  value       = aws_iam_role.ecs_task.arn
  description = "ARN của ECS task role"
}