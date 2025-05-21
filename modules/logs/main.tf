resource "aws_cloudwatch_log_group" "ecs" {
  for_each          = toset(var.services)
  name              = "/ecs/${each.key}"
  retention_in_days = var.retention_in_days
}