terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}

module "networking" {
  source                                  = "./modules/networking"
  instance_ami                            = var.instance_ami
  instance_type                           = var.instance_type
  key_name                                = var.key_name
  allow_ports                             = var.allow_ports
  general_tags                            = var.general_tags
  VPC_1_instance_tenancy                  = var.VPC_1_instance_tenancy
  VPC_1_cidr_block                        = var.VPC_1_cidr_block
  Public_subnet_1_cidr_block              = var.Public_subnet_1_cidr_block
  Public_subnet_1_availability_zone       = var.Public_subnet_1_availability_zone
  Public_subnet_1_map_public_ip_on_launch = var.Public_subnet_1_map_public_ip_on_launch
  Private_subnet_1_cidr_block             = var.Private_subnet_1_cidr_block
  Private_subnet_1_availability_zone      = var.Private_subnet_1_availability_zone
  eip_vpc                                 = var.eip_vpc
  VPC_2_instance_tenancy                  = var.VPC_2_instance_tenancy
  VPC_2_cidr_block                        = var.VPC_2_cidr_block
  Public_subnet_2_cidr_block              = var.Public_subnet_2_cidr_block
  Public_subnet_2_availability_zone       = var.Public_subnet_2_availability_zone
  Public_subnet_2_map_public_ip_on_launch = var.Public_subnet_2_map_public_ip_on_launch
  Private_subnet_2_cidr_block             = var.Private_subnet_2_cidr_block
  Private_subnet_2_availability_zone      = var.Private_subnet_2_availability_zone
  eip_2_vpc                               = var.eip_2_vpc
}


module "ec2" {
  source                                = "./modules/ec2"
  instance_ami                          = var.instance_ami
  instance_type                         = var.instance_type
  key_name                              = var.key_name
  general_tags                          = var.general_tags
  SG_Public_1_id                        = module.networking.SG_Public_1_id
  SG_Private_1_id                       = module.networking.SG_Private_1_id
  SG_Public_2_id                        = module.networking.SG_Public_2_id
  SG_Private_2_id                       = module.networking.SG_Private_2_id
  VPC_1_Public_Subnet                   = module.networking.VPC_1_Public_Subnet
  VPC_1_Private_Subnet                  = module.networking.VPC_1_Private_Subnet
  VPC_2_Public_Subnet                   = module.networking.VPC_2_Public_Subnet
  VPC_2_Private_Subnet                  = module.networking.VPC_2_Private_Subnet
  aws_instance_associate_public_address = var.aws_instance_associate_public_address
}
