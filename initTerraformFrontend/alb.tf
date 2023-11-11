#################### Port 3000 Target Group ####################
resource "aws_lb_target_group" "frontend_retail_tg" {
  name        = "D8-retailapp-app"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.deployment8_vpc.id

  health_check {
    enabled = true
    path    = "/"
  }

  depends_on = [aws_alb.retail_app]
}

#################### Application Load Balancer ####################
resource "aws_alb" "retail_app" {
  name               = "deployment8-retailapp-lb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    aws_subnet.deployment8_pubsub_a.id,
    aws_subnet.deployment8_pubsub_b.id
  ]

  security_groups = [
    aws_security_group.http_alb.id,
  ]

  depends_on = [aws_internet_gateway.deployment8_igw]
}

resource "aws_alb_listener" "frontend_retail_app_listener" {
  load_balancer_arn = aws_alb.retail_app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_retail_tg.arn
  }
}

output "alb_url" {
  value = "http://${aws_alb.retail_app.dns_name}"
}