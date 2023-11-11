variable aws_access_key {}
variable aws_secret_key {}

variable "deployment8_region" {
  default = "us-east-1" 
}

variable "deployment8_vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "deployment8_pubSubnet01_cidr" {
  default = "10.0.1.0/24"
}

variable "deployment8_pubSubnet02_cidr" {
  default = "10.0.2.0/24"
}

variable "deployment8_az1" {
  default = "us-east-1a"
}

variable "deployment8_az2" {
  default = "us-east-1b"  
}
