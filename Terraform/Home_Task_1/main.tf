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
  region = "us-east-1"
}

#-------------------------------------------vpc,acl and subnets--------------------------------------
resource "aws_vpc" "VPC_1" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}

resource "aws_subnet" "Public_subnet_1" {
  vpc_id            = aws_vpc.VPC_1.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "Private_subnet_1" {
  vpc_id            = aws_vpc.VPC_1.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_network_acl" "ACL_1" {
  vpc_id = aws_vpc.VPC_1.id

  egress {
    protocol   = "tcp"
    rule_no    = 200 # ?????
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100 # ?????
    action     = "allow"
    cidr_block = "10.3.0.0/18" # ?????
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "main"
  }
}

resource "aws_vpc" "VPC_2" {
  cidr_block       = "10.1.0.0/16"
  instance_tenancy = "default"
}

resource "aws_subnet" "Public_subnet_2" {
  vpc_id            = aws_vpc.VPC_2.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-east-1c"
}

resource "aws_subnet" "Private_subnet_2" {
  vpc_id            = aws_vpc.VPC_2.id
  cidr_block        = "10.1.2.0/24"
  availability_zone = "us-east-1d"
}







#----------------------------------------instance--------------------------------------------------

resource "aws_security_group" "sg_1" {
  name   = "sg_1"
  vpc_id = aws_vpc.VPC_1.id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 22
    to_port    = 22
  }
}

resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.Public_subnet_1.id
  private_ips = ["10.0.1.2"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_instance" "ec2_server" { # 1.2.3.4...?
  count         = 4
  ami           = "ami-08d70e59c07c61a3a"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }

  tags = {
    Name = var.instance_name
  }
}
