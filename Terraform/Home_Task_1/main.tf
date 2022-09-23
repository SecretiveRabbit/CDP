terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  backend "s3" {
    bucket = "oleksandr-stepanov-hometask-1-tf-state"
    dynamodb_table = "terraform-state-lock-dynamo"
    key    = "home-task-1/terraform.tfstate"
    region = "us-east-1"
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}

module "networking" {
  source                                          = "./modules/networking"
  instance_ami                                    = var.instance_ami
  instance_type                                   = var.instance_type
  key_name                                        = var.key_name
  allow_ports                                     = var.allow_ports
  general_tags                                    = var.general_tags
  vpc_1_instance_tenancy                          = var.vpc_1_instance_tenancy
  vpc_1_cidr_block                                = var.vpc_1_cidr_block
  public_subnet_1_cidr_block                      = var.public_subnet_1_cidr_block
  public_subnet_1_availability_zone               = var.public_subnet_1_availability_zone
  public_subnet_1_map_public_ip_on_launch         = var.public_subnet_1_map_public_ip_on_launch
  private_subnet_1_cidr_block                     = var.private_subnet_1_cidr_block
  private_subnet_1_availability_zone              = var.private_subnet_1_availability_zone
  eip_vpc                                         = var.eip_vpc
  vpc_2_instance_tenancy                          = var.vpc_2_instance_tenancy
  vpc_2_cidr_block                                = var.vpc_2_cidr_block
  public_subnet_2_cidr_block                      = var.public_subnet_2_cidr_block
  public_subnet_2_availability_zone               = var.public_subnet_2_availability_zone
  public_subnet_2_map_public_ip_on_launch         = var.public_subnet_2_map_public_ip_on_launch
  private_subnet_2_cidr_block                     = var.private_subnet_2_cidr_block
  private_subnet_2_availability_zone              = var.private_subnet_2_availability_zone
  eip_2_vpc                                       = var.eip_2_vpc
  vpc_peering_connection_auto_allow               = var.vpc_peering_connection_auto_allow
  vpc_peering_connection_peer_owner_id            = var.vpc_peering_connection_peer_owner_id
  aws_vpc_peering_connection_accepter_auto_accept = var.aws_vpc_peering_connection_accepter_auto_accept
}

module "ec2" {
  source                                = "./modules/ec2"
  instance_ami                          = var.instance_ami
  instance_type                         = var.instance_type
  key_name                              = var.key_name
  general_tags                          = var.general_tags
  sg_public_1_id                        = module.networking.sg_public_1_id
  sg_private_1_id                       = module.networking.sg_private_1_id
  sg_public_2_id                        = module.networking.sg_public_2_id
  sg_private_2_id                       = module.networking.sg_private_2_id
  vpc_1_public_subnet                   = module.networking.vpc_1_public_subnet
  vpc_1_private_subnet                  = module.networking.vpc_1_private_subnet
  vpc_2_public_subnet                   = module.networking.vpc_2_public_subnet
  vpc_2_private_subnet                  = module.networking.vpc_2_private_subnet
  aws_instance_associate_public_address = var.aws_instance_associate_public_address
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "terraform-state-lock-dynamo"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}
