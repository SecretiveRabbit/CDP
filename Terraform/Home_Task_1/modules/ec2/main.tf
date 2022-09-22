resource "aws_instance" "webserver_public_1" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = var.aws_instance_associate_public_address
  vpc_security_group_ids      = [var.SG_Public_1_id]
  subnet_id                   = var.VPC_1_Public_Subnet
  user_data                   = file("user_data.sh")

  tags = merge(var.general_tags, { Name = "Webserver_Public_1" })
}

resource "aws_instance" "webserver_private_1" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.SG_Private_1_id]
  subnet_id              = var.VPC_1_Private_Subnet

  tags = merge({ Name = "Webserver_Private_1" }, var.general_tags)
}

resource "aws_instance" "webserver_public_2" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = var.aws_instance_associate_public_address
  vpc_security_group_ids      = [var.SG_Public_2_id]
  subnet_id                   = var.VPC_2_Public_Subnet
  user_data                   = file("user_data.sh")

  tags = merge({ Name = "Webserver_Public_2" }, var.general_tags)
}

resource "aws_instance" "webserver_private_2" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.SG_Private_2_id]
  subnet_id              = var.VPC_2_Private_Subnet

  tags = merge({ Name = "Webserver_Private_2" }, var.general_tags)
}
