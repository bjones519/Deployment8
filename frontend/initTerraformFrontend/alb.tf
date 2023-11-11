#################### Port 3000 Target Group ####################
resource "aws_lb_target_group" "frontend_retail_tg" {
  name        = "D8-retailapp-app"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "vpc-09b5d002b7c8b6e92"

  health_check {
    enabled = true
    path    = "/health"
  }

  depends_on = [aws_alb.retail_app]
}

#################### Application Load Balancer ####################
resource "aws_alb" "retail_app" {
  name               = "deployment8-retailapp-lb"
  internal           = false
  load_balancer_type = "application"

  subnets = [
    "subnet-00c80cf7827df5774",
    "subnet-0df61200151e2b1cb"
  ]

  security_groups = [
    "sg-07eca7ab18ca6e9d4"
  ]

  depends_on = [igw-060a2fb9a831623f2]
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