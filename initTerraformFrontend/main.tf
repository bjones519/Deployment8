provider "aws" {
  region     = var.deployment8_region
  access_key = var.access_key
  secret_key = var.secret_key
  # profile = "Admin"
}


#################### Frontend Task Definition ####################

resource "aws_ecs_task_definition" "frontend_ecs_task" {
  family = "frontend-retail-task"

  container_definitions = <<EOF
  [
  {
      "name": "retailapp-container",
      "image": "bjones25/d8frontend:latest",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/retail-logs",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      },
      "portMappings": [
        {
          "containerPort": 3000
        }
      ]
    }
  ]
  EOF

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "1024"
  cpu                      = "512"
  execution_role_arn       = "arn:aws:iam::922751287048:role/ecsTaskExecutionRole"
  task_role_arn            = "arn:aws:iam::922751287048:role/ecsTaskExecutionRole"

}



#################### ECS Service Frontend ####################
resource "aws_ecs_service" "aws-ecs-service-frontend" {
  name                 = "frontend-retailapp-ecs-service"
  cluster              = aws_ecs_cluster.aws_ecs_cluster.id
  task_definition      = aws_ecs_task_definition.frontend_ecs_task.arn # security group allows 3000 from ALB SG
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 2
  force_new_deployment = true

  network_configuration {
    subnets = [
      aws_subnet.deployment8_pubsub_a.id,
      aws_subnet.deployment8_pubsub_b.id
    ]
    assign_public_ip = true
    security_groups  = [aws_security_group.ingress_traffic_frontend.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend_retail_tg.arn
    container_name   = "retailapp-container"
    container_port   = 3000
  }
}