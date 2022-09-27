terraform {
  backend "s3" {
    region = "us-east-1"
    bucket = "oleksandr-stepanov-hometask-2-tf-state"
    key    = "Home_Task_1/terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "networking" {
  source                                  = "./modules/networking"
  allow_ports                             = var.allow_ports
  general_tags                            = var.general_tags
  vpc_1_instance_tenancy                  = var.vpc_1_instance_tenancy
  vpc_1_cidr_block                        = var.vpc_1_cidr_block
  public_subnet_1_cidr_block              = var.public_subnet_1_cidr_block
  public_subnet_1_availability_zone       = var.public_subnet_1_availability_zone
  public_subnet_1_map_public_ip_on_launch = var.public_subnet_1_map_public_ip_on_launch
  private_subnet_1_cidr_block             = var.private_subnet_1_cidr_block
  private_subnet_1_availability_zone      = var.private_subnet_1_availability_zone
  eip_vpc                                 = var.eip_vpc
  public_subnet_2_cidr_block              = var.public_subnet_2_cidr_block
  private_subnet_2_availability_zone      = var.private_subnet_2_availability_zone
  private_subnet_2_cidr_block             = var.private_subnet_2_cidr_block
  public_subnet_2_availability_zone       = var.public_subnet_2_availability_zone
}


module "asg" {
  source              = "./modules/asg"
  public_subnet_1_id  = module.networking.vpc_1_public_subnet
  private_subnet_1_id = module.networking.vpc_1_private_subnet
  public_subnet_2_id  = module.networking.vpc_1_public_subnet_2
  private_subnet_2_id = module.networking.vpc_1_private_subnet_2
  sg_public_1_id      = module.networking.sg_public_1_id
  alb_sg              = module.networking.alb_sg
  vpc_id              = module.networking.vpc_id

  /*instance_ami                          = var.instance_ami
  instance_type                         = var.instance_type
  key_name                              = var.key_name
  general_tags                          = var.general_tags
  sg_public_1_id                        = module.networking.sg_public_1_id
  sg_private_1_id                       = module.networking.sg_private_1_id
  vpc_1_public_subnet                   = module.networking.vpc_1_public_subnet
  vpc_1_private_subnet                  = module.networking.vpc_1_private_subnet
  aws_instance_associate_public_address = var.aws_instance_associate_public_address */

}