resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "task" {
  for_each               = toset(var.services)
  family                 = each.key
  network_mode           = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                    = var.cpu
  memory                 = var.memory
  execution_role_arn     = var.execution_role_arn
  task_role_arn          = var.task_role_arn
  container_definitions  = jsonencode([{
    name      = each.key
    image     = var.ecr_repos[each.key]
    essential = true
    portMappings = [{ containerPort = var.container_port, hostPort = var.container_port }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/${each.key}"
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}

resource "aws_ecs_service" "svc" {
  for_each            = toset(var.services)
  name                = "${each.key}-service"
  cluster             = aws_ecs_cluster.main.id
  task_definition     = aws_ecs_task_definition.task[each.key].arn
  desired_count       = var.desired_count
  launch_type         = "FARGATE"
  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = var.target_group_arns[each.key]
    container_name   = each.key
    container_port   = var.container_port
  }
  depends_on = [aws_ecs_task_definition.task]
}