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
  region  = "us-east-1"
}

resource "aws_vpc" "VPC_1" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.VPC_1.id
}

resource "aws_subnet" "Public_subnet_1" {
  vpc_id            = aws_vpc.VPC_1.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "Private_subnet_1" {
  vpc_id            = aws_vpc.VPC_1.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_route_table" "MyRouteTable" {
  vpc_id = aws_vpc.VPC_1.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block = "10.0.2.0/24"
    nat_gateway_id = aws_nat_gateway.MyNAT_GTW.id
  }

  tags = {
    Name = "MyRouteTable"
  }
}

resource "aws_nat_gateway" "MyNAT_GTW" {
  allocation_id = aws_eip.eip_1.id
  subnet_id     = aws_subnet.Public_subnet_1.id

 tags = {
    Name = "gw NAT"
  }

 # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "eip_1" {
  vpc = true
  depends_on                = [aws_internet_gateway.igw]
}

resource "aws_network_acl" "ACL_1" {
  vpc_id = aws_vpc.VPC_1.id

  egress {
    protocol   = "tcp"
    rule_no    = 200 # ?????
    action     = "allow"
    cidr_block = "10.0.1.0/24"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100 # ?????
    action     = "allow"
    cidr_block = "10.0.1.0/24" # ?????
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "main"
  }
}

resource "aws_network_acl" "ACL_2" {
  vpc_id = aws_vpc.VPC_1.id

  egress {
    protocol   = "tcp"
    rule_no    = 100 # ?????
    action     = "allow"
    cidr_block = "10.0.1.0/24"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100 # ?????
    action     = "allow"
    cidr_block = "10.0.2.0/24"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100 # ?????
    action     = "allow"
    cidr_block = "10.0.1.0/24" # ?????
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 100 # ?????
    action     = "allow"
    cidr_block = "10.0.2.0/24" # ?????
    from_port  = 80
    to_port    = 80
  }
  tags = {
    Name = "main"
  }
}

resource "aws_security_group" "sg_public" {
  name   = "sg_1"
  vpc_id = aws_vpc.VPC_1.id

  ingress {
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port  = 22
    to_port    = 22
  }
}

resource "aws_security_group" "sg_private" {
  name   = "sg_1"
  vpc_id = aws_vpc.VPC_1.id

  ingress {
    protocol   = "tcp"
    cidr_blocks = ["10.0.2.0/24"]
    from_port  = 22
    to_port    = 22
  }
}

resource "aws_network_interface" "foo_1" {
  subnet_id   = aws_subnet.Public_subnet_1.id
  private_ips = ["10.0.1.2"]

  tags = {
    Name = "primary_network_interface"
  }
}

resource "aws_network_interface" "foo_2" {
  subnet_id   = aws_subnet.Private_subnet_1.id
  private_ips = ["10.0.2.2"]

  tags = {
    Name = "primary_network_interface"
  }
}

/*
resource "aws_key_pair" "webserver-key" {
  key_name   = "webserver-key"
  public_key = file("~/.ssh/id_rsa.pub")
}
*/
resource "aws_key_pair" "MyKeyPair" {
  key_name   = "webserver-key"
  public_key = file("${path.module}/id_rsa.pub")
}

resource "aws_instance" "webserver_public_1" {
  ami                         = "ami-05fa00d4c63e32376"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.MyKeyPair.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg_public.id]
  subnet_id                   = aws_subnet.Public_subnet_1.id
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd && sudo systemctl start httpd",
      "echo '<h1><center>My Test Website With Help From Terraform Provisioner</center></h1>' > index.html",
      "sudo mv index.html /var/www/html/"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("${path.module}/id_rsa.pub")}"
      host        = self.public_ip
    }
  }
  tags = {
    Name = "webserver"
  }
}

resource "aws_instance" "webserver_private_1" {
  ami                         = "ami-05fa00d4c63e32376"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.MyKeyPair.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg_private.id]
  subnet_id                   = aws_subnet.Private_subnet_1.id
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd && sudo systemctl start httpd",
      "echo '<h1><center>My Test Website With Help From Terraform Provisioner</center></h1>' > index.html",
      "sudo mv index.html /var/www/html/"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      #private_key = file("${path.module}/id_rsa.pub")
      private_key = "${file("${path.module}/id_rsa.pub")}"
      host        = self.public_ip
    }
  }
  tags = {
    Name = "webserver"
  }
}

output "Webserver-Public-IP" {
  value = aws_instance.webserver_public_1.public_ip
}

resource "aws_route" "public_route_1" {
  route_table_id         = aws_vpc.VPC_1.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "PrivateRouteTable" {
  vpc_id = aws_vpc.VPC_1.id

  route {
    cidr_block = "10.0.2.0/24"
    nat_gateway_id = aws_nat_gateway.MyNAT_GTW.id
  }

  tags = {
    Name = "MyRouteTable"
  }
}

resource "aws_route_table_association" "RT_for_public" {
  subnet_id      = aws_subnet.Public_subnet_1.id
  route_table_id = aws_vpc.VPC_1.default_route_table_id
}

resource "aws_route_table_association" "RT_for_private" {
  subnet_id      = aws_subnet.Public_subnet_1.id
  route_table_id = aws_route_table.PrivateRouteTable.id
}
