#-----------------------------------general---------------------------------------------

variable "region" {
  type    = string
  default = "us-east-1"
}
variable "general_tags" {
  description = "Tags that are applied to most of the resources"
  type        = map(any)
  default = {
    Creator = "Oleksandr Stepanov"
    Project = "Home Task"
  }
}
#----------------------------------networking-----------------------------------------
variable "vpc_1_instance_tenancy" {
  type    = string
  default = "default"
}
variable "vpc_1_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}
variable "public_subnet_1_cidr_block" {
  type    = string
  default = "10.0.1.0/24"
}
variable "public_subnet_1_availability_zone" {
  type    = string
  default = "us-east-1a"
}
variable "public_subnet_2_cidr_block" {
  type    = string
  default = "10.0.11.0/24"
}
variable "public_subnet_2_availability_zone" {
  type    = string
  default = "us-east-1b"
}
variable "public_subnet_1_map_public_ip_on_launch" {
  type    = bool
  default = true
}
variable "private_subnet_1_cidr_block" {
  type    = string
  default = "10.0.2.0/24"
}
variable "private_subnet_1_availability_zone" {
  type    = string
  default = "us-east-1a"
}
variable "private_subnet_2_availability_zone" {
  type    = string
  default = "us-east-1b"
}
variable "private_subnet_2_cidr_block" {
  type    = string
  default = "10.0.12.0/24"
}
variable "eip_vpc" {
  type    = bool
  default = true
}
variable "allow_ports" {
  default = ["22", "80", "1256"]
}

#---------------------------------------------ec2------------------------------------------
variable "aws_instance_associate_public_address" {
  type    = bool
  default = true
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "key_name" {
  type    = string
  default = "TEST"
}
variable "instance_ami" {
  type    = string
  default = "ami-05fa00d4c63e32376"
}

#-------------------------------------------alb---------------------------------------------
variable "alb_target_port" {
  type    = string
  default = "80"
}

#-------------------------------------------asg---------------------------------------------
variable "asg_min_size" {
  type    = number
  default = 2
}
variable "asg_desired_capacity" {
  type    = number
  default = 2
}
variable "asg_max_size" {
  type    = number
  default = 3
}
variable "pub_sg_cidr_for_asg" {
  description = "CIDR block for public subnet"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
variable "pub_sg_ingress_from_port" {
  type    = number
  default = 22
}
variable "pub_sg_ingress_to_port" {
  type    = number
  default = 22
}
variable "pub_sg_egress_from_port" {
  type    = number
  default = 0
}
variable "pub_sg_egress_to_port" {
  type    = number
  default = 0
}
variable "priv_sg_ingress_from_port" {
  type    = number
  default = 80
}
variable "priv_sg_ingress_to_port" {
  type    = number
  default = 80
}
variable "priv_sg_egress_from_port" {
  type    = number
  default = 0
}
variable "priv_sg_egress_to_port" {
  type    = number
  default = 0
}
variable "priv_sg_cidr_for_asg" {
  description = "CIDR block for public subnet"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}