resource "aws_vpc" "vpc_1" {
  cidr_block = var.vpc_1_cidr_block
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
}

resource "aws_eip" "eip_1" {}

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

resource "aws_route_table_association" "rt_for_private" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "rt_for_private_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

