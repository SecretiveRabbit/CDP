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
#-----------------------------------networking-----------------------------------------
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
  default = "us-east-1b"
}
variable "eip_vpc" {
  type    = bool
  default = true
}
variable "vpc_2_instance_tenancy" {
  type    = string
  default = "default"
}
variable "vpc_2_cidr_block" {
  type    = string
  default = "10.1.0.0/16"
}
variable "public_subnet_2_cidr_block" {
  type    = string
  default = "10.1.11.0/24"
}
variable "public_subnet_2_availability_zone" {
  type    = string
  default = "us-east-1c"
}
variable "public_subnet_2_map_public_ip_on_launch" {
  type    = bool
  default = true
}
variable "private_subnet_2_cidr_block" {
  type    = string
  default = "10.1.12.0/24"
}
variable "private_subnet_2_availability_zone" {
  type    = string
  default = "us-east-1d"
}
variable "eip_2_vpc" {
  type    = bool
  default = true
}
#------------------------------------------ec2----------------------------------------------
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
variable "allow_ports" {
  default = ["22", "80", "1256"]
}
variable "aws_instance_associate_public_address" {
  type    = bool
  default = true
}
variable "vpc_peering_connection_auto_allow" {
  default = true
}
variable "vpc_peering_connection_peer_owner_id" {
  default = "619639349427"
}
variable "aws_vpc_peering_connection_accepter_auto_accept" {
  default = true
}
