resource "aws_vpc" "VPC_1" {
  cidr_block       = var.VPC_1_cidr_block
  instance_tenancy = var.VPC_1_instance_tenancy
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.VPC_1.id
}

resource "aws_subnet" "Public_subnet_1" {
  vpc_id                  = aws_vpc.VPC_1.id
  cidr_block              = var.Public_subnet_1_cidr_block
  availability_zone       = var.Public_subnet_1_availability_zone
  map_public_ip_on_launch = var.Public_subnet_1_map_public_ip_on_launch
}

resource "aws_subnet" "Private_subnet_1" {
  vpc_id            = aws_vpc.VPC_1.id
  cidr_block        = var.Private_subnet_1_cidr_block
  availability_zone = var.Private_subnet_1_availability_zone
}

resource "aws_nat_gateway" "MyNAT_GTW" {
  allocation_id = aws_eip.eip_1.id
  subnet_id     = aws_subnet.Public_subnet_1.id

  tags = merge({ Name = "GW_NAT_1" }, var.general_tags)

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "eip_1" {
  vpc        = var.eip_vpc
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_network_acl" "ACL_1" {
  vpc_id = aws_vpc.VPC_1.id

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
  vpc_id = aws_vpc.VPC_1.id

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
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
  vpc_id = aws_vpc.VPC_1.id

  ingress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #["10.0.1.0/24"]
    from_port   = 0
    to_port     = 0
  }/*
  ingress {
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] # try to set ["10.1.11.0/24"] later ["0.0.0.0/0"]
    from_port   = -1
    to_port     = -1
  }*/
  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }/*
  egress {
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] # try to set ["10.1.11.0/24"] later
    from_port   = -1
    to_port     = -1
  }*/
}

resource "aws_route" "public_route_1" {
  route_table_id         = aws_vpc.VPC_1.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "PrivateRouteTable" {
  vpc_id = aws_vpc.VPC_1.id

  route {
    cidr_block     = "10.0.2.0/24"
    nat_gateway_id = aws_nat_gateway.MyNAT_GTW.id
  }
  route {
    cidr_block                = aws_vpc.VPC_2.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.VPC_1-VPC_2.id
  }
  tags = merge({ Name = "MyPrivateRouteTable_1" }, var.general_tags)
}

resource "aws_route_table_association" "RT_for_public" {
  subnet_id      = aws_subnet.Public_subnet_1.id
  route_table_id = aws_vpc.VPC_1.default_route_table_id
}


resource "aws_route_table_association" "RT_for_private" {
  subnet_id      = aws_subnet.Private_subnet_1.id
  route_table_id = aws_route_table.PrivateRouteTable.id
}

# --------------------------------------------------Network 2--------------------------------------------------

resource "aws_vpc" "VPC_2" {
  cidr_block       = var.VPC_2_cidr_block # set to 10.1.0.0/16
  instance_tenancy = var.VPC_2_instance_tenancy
}

resource "aws_internet_gateway" "igw_2" {
  vpc_id = aws_vpc.VPC_2.id
}

resource "aws_subnet" "Public_subnet_2" {
  vpc_id                  = aws_vpc.VPC_2.id
  cidr_block              = var.Public_subnet_2_cidr_block
  availability_zone       = var.Public_subnet_2_availability_zone
  map_public_ip_on_launch = var.Public_subnet_2_map_public_ip_on_launch
}

resource "aws_subnet" "Private_subnet_2" {
  vpc_id            = aws_vpc.VPC_2.id
  cidr_block        = var.Private_subnet_2_cidr_block
  availability_zone = var.Private_subnet_2_availability_zone
}

resource "aws_nat_gateway" "MyNAT_GTW_2" {
  allocation_id = aws_eip.eip_2.id
  subnet_id     = aws_subnet.Public_subnet_2.id

  tags = merge({ Name = "GW_NAT_2" }, var.general_tags)

  depends_on = [aws_internet_gateway.igw_2]
}

resource "aws_eip" "eip_2" {
  vpc        = var.eip_2_vpc
  depends_on = [aws_internet_gateway.igw_2]
}

resource "aws_network_acl" "ACL_2" {
  vpc_id = aws_vpc.VPC_2.id

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

  tags = merge({ Name = "ACL_VPC_2" }, var.general_tags)
}

resource "aws_security_group" "sg_public_2" {
  name   = "sg_pub_2"
  vpc_id = aws_vpc.VPC_2.id

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }
}

resource "aws_security_group" "sg_private_2" {
  name   = "sg_priv_2"
  vpc_id = aws_vpc.VPC_2.id

  ingress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #["10.1.11.0/24"]
    from_port   = 0
    to_port     = 0
  }/*
  ingress {
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] # try to set ["10.1.11.0/24"] later
    from_port   = -1
    to_port     = -1
  }*/
  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }/*
  egress {
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"] # try to set ["10.1.11.0/24"] later
    from_port   = -1
    to_port     = -1
  }*/
}

resource "aws_route" "public_route_2" {
  route_table_id         = aws_vpc.VPC_2.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw_2.id
}

resource "aws_route_table" "PrivateRouteTable_2" {
  vpc_id = aws_vpc.VPC_2.id

  route {
    cidr_block     = "10.1.12.0/24"
    nat_gateway_id = aws_nat_gateway.MyNAT_GTW_2.id
  }

  route {
    cidr_block                = aws_vpc.VPC_1.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.VPC_1-VPC_2.id
  }

  tags = merge({ Name = "MyPrivateRouteTable_2" }, var.general_tags)
}

resource "aws_route_table_association" "RT_for_public_2" {
  subnet_id      = aws_subnet.Public_subnet_2.id
  route_table_id = aws_vpc.VPC_2.default_route_table_id
}

resource "aws_route_table_association" "RT_for_private_2" {
  subnet_id      = aws_subnet.Private_subnet_2.id
  route_table_id = aws_route_table.PrivateRouteTable_2.id
}

#---------------------------------------VPC Peering------------------------------------------------------

resource "aws_vpc_peering_connection" "VPC_1-VPC_2" {
  peer_owner_id = var.vpc_peering_connection_peer_owner_id
  peer_vpc_id   = aws_vpc.VPC_2.id
  vpc_id        = aws_vpc.VPC_1.id
  auto_accept   = var.vpc_peering_connection_auto_allow
}
resource "aws_vpc_peering_connection_accepter" "peering_accept" {
  vpc_peering_connection_id = aws_vpc_peering_connection.VPC_1-VPC_2.id
  auto_accept               = var.aws_vpc_peering_connection_accepter_auto_accept
}
