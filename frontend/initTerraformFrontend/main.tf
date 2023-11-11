provider "aws" {
  region     = var.deployment8_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
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
  cluster              = "arn:aws:ecs:us-east-1:922751287048:cluster/retail-app-cluster"
  task_definition      = aws_ecs_task_definition.frontend_ecs_task.arn # security group allows 3000 from ALB SG
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 2
  force_new_deployment = true

  network_configuration {
    subnets = [
      "subnet-00c80cf7827df5774",
      "subnet-0df61200151e2b1cb"
    ]
    assign_public_ip = true
    security_groups  = ["sg-0963068ecd7dfd122"]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend_retail_tg.arn
    container_name   = "retailapp-container"
    container_port   = 3000
  }
}