region = "us-east-1"
general_tags = {
  Creator = "Oleksandr Stepanov"
  Project = "Home Task"
}
#-------------------------------------------ec2 module--------------------------------------------
instance_type                         = "t2.micro"
key_name                              = "TEST"
instance_ami                          = "ami-05fa00d4c63e32376"
aws_instance_associate_public_address = true
#----------------------------------------networking module-----------------------------------------
vpc_1_instance_tenancy                          = "default"
vpc_1_cidr_block                                = "10.0.0.0/16"
public_subnet_1_cidr_block                      = "10.0.1.0/24"
public_subnet_1_availability_zone               = "us-east-1a"
public_subnet_1_map_public_ip_on_launch         = true
private_subnet_1_cidr_block                     = "10.0.2.0/24"
private_subnet_1_availability_zone              = "us-east-1b"
eip_vpc                                         = true
vpc_2_instance_tenancy                          = "default"
vpc_2_cidr_block                                = "10.1.0.0/16"
public_subnet_2_cidr_block                      = "10.1.11.0/24"
public_subnet_2_availability_zone               = "us-east-1c"
public_subnet_2_map_public_ip_on_launch         = true
private_subnet_2_cidr_block                     = "10.1.12.0/24"
private_subnet_2_availability_zone              = "us-east-1d"
eip_2_vpc                                       = true
aws_vpc_peering_connection_accepter_auto_accept = true
vpc_peering_connection_peer_owner_id            = "619639349427"
vpc_peering_connection_auto_allow               = true
allow_ports                                     = ["22", "80", "8080", "3000"]