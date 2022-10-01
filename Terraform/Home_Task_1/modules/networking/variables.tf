variable "instance_type" {}
variable "key_name" {}
variable "instance_ami" {}
variable "allow_ports" {}
variable "general_tags" {}
variable "vpc_1_instance_tenancy" {}
variable "vpc_1_cidr_block" {}
variable "public_subnet_1_cidr_block" {}
variable "public_subnet_1_availability_zone" {}
variable "public_subnet_1_map_public_ip_on_launch" {}
variable "private_subnet_1_cidr_block" {}
variable "private_subnet_1_availability_zone" {}
variable "eip_vpc" {}
variable "vpc_2_instance_tenancy" {}
variable "vpc_2_cidr_block" {}
variable "public_subnet_2_cidr_block" {}
variable "public_subnet_2_availability_zone" {}
variable "public_subnet_2_map_public_ip_on_launch" {}
variable "private_subnet_2_cidr_block" {}
variable "private_subnet_2_availability_zone" {}
variable "eip_2_vpc" {}
variable "vpc_peering_connection_auto_allow" {}
variable "vpc_peering_connection_peer_owner_id" {}
variable "aws_vpc_peering_connection_accepter_auto_accept" {}