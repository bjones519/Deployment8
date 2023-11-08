#################### Configure AWS provider ####################

provider "aws" {
  region     = var.deployment8_region
  access_key = var.access_key
  secret_key = var.secret_key
  # profile = "Admin"
}

#################### ECS Cluster ####################
resource "aws_ecs_cluster" "aws_ecs_cluster" {
  name = "retail-app-cluster"
  tags = {
    Name = "retail-ecs"
  }
}

resource "aws_cloudwatch_log_group" "retail_log_group" {
  name = "/ecs/retail-logs"

  tags = {
    Application = "retail-app"
  }
}

#################### Frontend Task Definition ####################

resource "aws_ecs_task_definition" "frontend_ecs_task" {
  family = "frontend-retail-task"

  container_definitions = <<EOF
  [
  {
      "name": "retailapp-container",
      "image": "bdunu24/retailapp:latest",
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

#################### Backend Task Definition ####################

resource "aws_ecs_task_definition" "backend_ecs_task" {
  family = "frontend-retail-task"

  container_definitions = <<EOF
  [
  {
      "name": "retailapp-container",
      "image": "bdunu24/retailapp:latest",
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
          "containerPort": 8000
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
    assign_public_ip = false
    security_groups  = [aws_security_group.http_alb.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend_retail_tg.arn
    container_name   = "retailapp-container"
    container_port   = 3000
  }
}

#################### ECS Service Backend ####################
resource "aws_ecs_service" "aws-ecs-service-backend" {
  name                 = "backend-retailapp-ecs-service"
  cluster              = aws_ecs_cluster.aws_ecs_cluster.id
  task_definition      = aws_ecs_task_definition.backend_ecs_task.arn # security group allows 8000 from ALB SG
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

  network_configuration {
    subnets = [
      aws_subnet.deployment8_pubsub_a.id,
      aws_subnet.deployment8_pubsub_b.id
    ]
    assign_public_ip = false
    security_groups  = [aws_security_group.http_alb.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend_retail_tg.arn
    container_name   = "retailapp-container"
    container_port   = 8000
  }
}