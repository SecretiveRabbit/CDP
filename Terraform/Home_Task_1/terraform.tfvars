region = "us-east-1"
general_tags = {
  Creator = "Oleksandr Stepanov"
  Project = "Home Task"
}
#-------------------------------------------ec2 module--------------------------------------------
instance_type                         = "t2.micro"
key_name                              = "TEST"
allow_ports                           = ["22", "80", "1256"]
instance_ami                          = "ami-05fa00d4c63e32376"
aws_instance_associate_public_address = true
#----------------------------------------networking module-----------------------------------------
VPC_1_instance_tenancy                  = "default"
VPC_1_cidr_block                        = "10.0.0.0/16"
Public_subnet_1_cidr_block              = "10.0.1.0/24"
Public_subnet_1_availability_zone       = "us-east-1a"
Public_subnet_1_map_public_ip_on_launch = true
Private_subnet_1_cidr_block             = "10.0.2.0/24"
Private_subnet_1_availability_zone      = "us-east-1b"
eip_vpc                                 = true
VPC_2_instance_tenancy                  = "default"
VPC_2_cidr_block                        = "10.1.0.0/16"
Public_subnet_2_cidr_block              = "10.1.11.0/24"
Public_subnet_2_availability_zone       = "us-east-1c"
Public_subnet_2_map_public_ip_on_launch = true
Private_subnet_2_cidr_block             = "10.1.12.0/24"
Private_subnet_2_availability_zone      = "us-east-1d"
eip_2_vpc                               = true
