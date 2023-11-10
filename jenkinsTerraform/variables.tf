#################### variables ####################

#################### AWS credentials ####################

variable "access_key" {}
variable "secret_key" {}

#################### SSH key ####################
variable "key_name" {}

#################### Regions ####################
variable "region" {
  default = "us-east-1"
}

#################### EC2 Config ####################
variable "vpc_id" {}

variable "deployment8_instance_type" {
  default = "t2.medium"
}

variable "ami" {
  default = "ami-053b0d53c279acc90"
}