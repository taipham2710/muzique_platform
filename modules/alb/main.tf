resource "aws_security_group" "alb" {
  name   = "alb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Add HTTP ingress rule
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "this" {
  name               = "muzique-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_target_group" "tg" {
  for_each    = toset(var.services)
  name        = "${each.key}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path    = "/health"
    matcher = "200"
  }
}

# Create HTTP listener when no certificate is available
resource "aws_lb_listener" "http" {
  count             = var.certificate_arn == "" ? 1 : 0
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

# Create HTTPS listener only when certificate is available
resource "aws_lb_listener" "https" {
  count             = var.certificate_arn != "" ? 1 : 0
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "svc" {
  for_each     = toset(var.services)
  listener_arn = var.certificate_arn != "" ? aws_lb_listener.https[0].arn : aws_lb_listener.http[0].arn
  priority     = 10 + index(var.services, each.key)
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[each.key].arn
  }
  condition {
    path_pattern { values = ["/${each.key}/*", "/api/${each.key}/*"] }
  }
}