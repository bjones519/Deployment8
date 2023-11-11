output "ecs_cluster_id" {
  value = aws_ecs_cluster.aws_ecs_cluster.id
}

output "vpc_id" {
  value = aws_vpc.deployment8_vpc.id
}

output "aws_subnet_a" {
  value = aws_subnet.deployment8_pubsub_a.id
}

output "aws_subnet_b" {
  value = aws_subnet.deployment8_pubsub_b.id
}


output "aws_security_group_http_alb" {
  value = aws_security_group.http_alb.id
}


output "aws_internet_gateway" {
  value = aws_internet_gateway.deployment8_igw.id
}