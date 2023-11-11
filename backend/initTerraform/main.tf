#################### Configure AWS provider ####################

provider "aws" {
  region     = var.deployment8_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
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

#################### ECS Backend Task Definition ####################

resource "aws_ecs_task_definition" "backend_ecs_task" {
  family = "backend-retail-task"

  container_definitions = <<EOF
  [
  {
      "name": "retailapp-container",
      "image": "bjones25/d8backend:latest",
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
      aws_subnet.deployment8_pubsub_a.id
    ]
    assign_public_ip = true
    security_groups  = [aws_security_group.ingress_traffic_backend.id]
  }
}