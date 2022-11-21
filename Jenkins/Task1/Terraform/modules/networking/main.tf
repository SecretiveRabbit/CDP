resource "aws_vpc" "vpc_1" {
  cidr_block       = var.vpc_1_cidr_block
  instance_tenancy = var.vpc_1_instance_tenancy
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_1.id
}

resource "aws_route" "public_route_1" {
  route_table_id         = aws_vpc.vpc_1.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.vpc_1.id
  cidr_block              = var.public_subnet_1_cidr_block
  availability_zone       = var.public_subnet_1_availability_zone
  map_public_ip_on_launch = var.public_subnet_1_map_public_ip_on_launch
}

resource "aws_security_group" "sg_public" {
  name   = "sg_pub_1"
  vpc_id = aws_vpc.vpc_1.id

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

