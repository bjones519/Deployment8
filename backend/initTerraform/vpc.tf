#################### VPC ####################
resource "aws_vpc" "deployment8_vpc" {
  cidr_block = var.deployment8_vpc_cidr
  tags = {
    "Name" = "deployment8-vpc"
  }
}

output "vpc_id" {
  value = aws_vpc.deployment8_vpc.id
}

#################### Subnets ####################
resource "aws_subnet" "deployment8_pubsub_a" {
  vpc_id            = aws_vpc.deployment8_vpc.id
  cidr_block        = var.deployment8_pubSubnet01_cidr
  availability_zone = var.deployment8_az1

  tags = {
    "Name" = "pubsubA"
  }
}

resource "aws_subnet" "deployment8_pubsub_b" {
  vpc_id            = aws_vpc.deployment8_vpc.id
  cidr_block        = var.deployment8_pubSubnet02_cidr
  availability_zone = var.deployment8_az2

  tags = {
    "Name" = "pubsubB"
  }
}

#################### Rte Tble Associations ####################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.deployment8_vpc.id
}

resource "aws_route_table_association" "public_subnet_a" {
  subnet_id      = aws_subnet.deployment8_pubsub_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet_b" {
  subnet_id      = aws_subnet.deployment8_pubsub_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "elastic-ip" {
  domain = "vpc"
}

resource "aws_internet_gateway" "deployment8_igw" {
  vpc_id = aws_vpc.deployment8_vpc.id
}

resource "aws_security_group" "http_alb" {
  name        = "httpalb"
  description = "HTTP ALB traffic"
  vpc_id      = aws_vpc.deployment8_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "HTTP ALB ingresstraffic"
  }
}

resource "aws_security_group" "ingress_traffic_frontend" {
  name        = "ingress-app-frontend"
  description = "Allow ingress to frontend of APP"
  vpc_id      = aws_vpc.deployment8_vpc.id
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "ingress-app-frontend-security-group"
  }
}

resource "aws_security_group" "ingress_traffic_backend" {
  name        = "ingress-app-backend"
  description = "Allow ingress to backend of APP"
  vpc_id      = aws_vpc.deployment8_vpc.id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name" = "ingress-app-backend-security-group"
  }
}