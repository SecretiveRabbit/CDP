resource "aws_vpc" "vpc_1" {
  cidr_block       = var.vpc_1_cidr_block
  instance_tenancy = var.vpc_1_instance_tenancy
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_1.id
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.vpc_1.id
  cidr_block              = var.public_subnet_1_cidr_block
  availability_zone       = var.public_subnet_1_availability_zone
  map_public_ip_on_launch = var.public_subnet_1_map_public_ip_on_launch
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.vpc_1.id
  cidr_block              = var.public_subnet_2_cidr_block
  availability_zone       = var.public_subnet_2_availability_zone
  map_public_ip_on_launch = var.public_subnet_1_map_public_ip_on_launch
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = var.private_subnet_1_cidr_block
  availability_zone = var.private_subnet_1_availability_zone
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = var.private_subnet_2_cidr_block
  availability_zone = var.private_subnet_2_availability_zone
}

resource "aws_nat_gateway" "nat_gtw_1" {
  allocation_id = aws_eip.eip_1.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = merge({ Name = "GW_NAT_1" }, var.general_tags)

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "eip_1" {
  vpc        = var.eip_vpc
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_network_acl" "acl_1" {
  vpc_id = aws_vpc.vpc_1.id

  ingress {
    protocol   = "tcp"
    rule_no    = 100 # ?????
    action     = "allow"
    cidr_block = "0.0.0.0/0" # ?????
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 100 # ?????
    action     = "allow"
    cidr_block = "0.0.0.0/0" # ?????
    from_port  = 80
    to_port    = 80
  }

  tags = merge({ Name = "ACL_VPC_1" }, var.general_tags)
}

resource "aws_security_group" "sg_public" {
  name   = "sg_pub_1"
  vpc_id = aws_vpc.vpc_1.id
  /*
  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  */
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
  }
  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }
}

resource "aws_security_group" "sg_private" {
  name   = "sg_priv_1"
  vpc_id = aws_vpc.vpc_1.id

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #["10.0.1.0/24"]
    from_port   = 80
    to_port     = 80
  }

  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }


}

resource "aws_route" "public_route_1" {
  route_table_id         = aws_vpc.vpc_1.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc_1.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gtw_1.id
  }

  tags = merge({ Name = "MyPrivateRouteTable_1" }, var.general_tags)
}

resource "aws_route_table_association" "rt_for_public" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_vpc.vpc_1.default_route_table_id
}

resource "aws_route_table_association" "rt_for_public_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_vpc.vpc_1.default_route_table_id
}

resource "aws_route_table_association" "rt_for_private" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "rt_for_private_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

#------------------------------load balancer sg-----------------------------------
resource "aws_security_group" "alb" {
  name        = "terraform_alb_security_group"
  description = "Terraform load balancer security group"
  vpc_id      = aws_vpc.vpc_1.id
  /*
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }*/

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
