terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  backend "s3" {
    bucket         = "oleksandr-stepanov-hometask-1-tf-state"
    dynamodb_table = "terraform-state-lock-dynamo"
    key            = "home-task-1/terraform.tfstate"
    region         = "us-east-1"
  }
  required_version = ">= 1.2.0"
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraform-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}

module "networking" {
  source                                  = "./modules/networking"
  instance_ami                            = var.instance_ami
  instance_type                           = var.instance_type
  key_name                                = var.key_name
  allow_ports                             = var.allow_ports
  general_tags                            = var.general_tags
  vpc_1_instance_tenancy                  = var.vpc_1_instance_tenancy
  vpc_1_cidr_block                        = var.vpc_1_cidr_block
  public_subnet_1_cidr_block              = var.public_subnet_1_cidr_block
  public_subnet_1_availability_zone       = var.public_subnet_1_availability_zone
  public_subnet_1_map_public_ip_on_launch = var.public_subnet_1_map_public_ip_on_launch
}

module "ec2" {
  source                                = "./modules/ec2"
  instance_ami                          = var.instance_ami
  instance_type                         = var.instance_type
  key_name                              = var.key_name
  general_tags                          = var.general_tags
  sg_public_1_id                        = module.networking.sg_public_1_id
  vpc_1_public_subnet                   = module.networking.vpc_1_public_subnet
  aws_instance_associate_public_address = var.aws_instance_associate_public_address
}