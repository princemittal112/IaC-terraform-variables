variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnet_count" {
  default = 1
}

variable "private_subnet_count" {
  default = 1
}

variable "ec2_instance_count" {
  default = 6
}

variable "ec2_ami" {
  default = "ami-09e6f87a47903347c"
}

variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "ec2_subnet_type" {
  default = "public"
}
