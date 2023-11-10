#################### variables ####################

#################### AWS credentials ####################

variable access_key {}
variable secret_key {}

#################### SSH key ####################
variable "key_name" {}

#################### Regions ####################
variable "deployment8_region" {
  default = "us-east-1" 
}

#################### VPC and Subnets ####################

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

variable "deployment8_instance_type" {
  default = "t2.medium"
}

variable "ami" {
  default = "ami-053b0d53c279acc90"
}