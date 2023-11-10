#################### Configure AWS provider ####################
#################### based on https://registry.terraform.io/providers/hashicorp/aws/latest/docs ####################
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  # profile = "Admin"
}

#################### Configure Jenkins infrastructure ####################

#################### Instance #1 - Jenkins Manager ####################
resource "aws_instance" "deployment8_jenkins_manager" {
  ami                         = var.ami
  instance_type               = var.deployment8_instance_type
  vpc_security_group_ids      = [aws_security_group.jenkins.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  subnet_id = "subnet-098c6f6d70b6fbfce"
  user_data = file("jenkins-manager-installs.sh")
  tags = {
    Name = "jenkins-manager-east"
  }
}

#################### Instance #2 - Jenkins Agent01 ####################
resource "aws_instance" "deployment8_jenkins_agent01" {
  ami                         = var.ami
  instance_type               = var.deployment8_instance_type
  vpc_security_group_ids      = [aws_security_group.jenkins_agent.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  subnet_id = "subnet-098c6f6d70b6fbfce"
  user_data = file("jenkins-agent01-installs.sh")
  tags = {
    Name = "jenkins-agent01-east"
  }

}

#################### Instance #3 - Jenkins Agent02 ####################
resource "aws_instance" "deployment8_jenkins_agent02" {
  ami                         = var.ami
  instance_type               = var.deployment8_instance_type
  vpc_security_group_ids      = [aws_security_group.jenkins_agent.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  subnet_id = "subnet-0427a771f050fbb05"
  user_data = file("jenkins-agent02-installs.sh")
  tags = {
    Name = "jenkins-agent02-east"
  }
}

#################### Configure security group ####################
#################### Based on https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group ####################
resource "aws_security_group" "jenkins" {
  vpc_id = var.vpc_id

  ingress {
    description = "allow incoming SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow incoming traffic on port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "sg_name" : "jenkins_sg"
    "terraform" : "true"
  }
}

resource "aws_security_group" "jenkins_agent" {
  vpc_id = var.vpc_id

  ingress {
    description = "allow incoming SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "sg_name" : "jenkins_agent_sg"
    "terraform" : "true"
  }
}