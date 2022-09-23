resource "aws_instance" "webserver_public_1" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = var.aws_instance_associate_public_address
  vpc_security_group_ids      = [var.sg_public_1_id]
  subnet_id                   = var.vpc_1_public_subnet
  user_data                   = file("user_data.sh")

  tags = merge(var.general_tags, { Name = "Webserver_Public_1" })
}

resource "aws_instance" "webserver_private_1" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.sg_private_1_id]
  subnet_id              = var.vpc_1_private_subnet

  tags = merge({ Name = "Webserver_Private_1" }, var.general_tags)
}

resource "aws_instance" "webserver_public_2" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = var.aws_instance_associate_public_address
  vpc_security_group_ids      = [var.sg_public_2_id]
  subnet_id                   = var.vpc_2_public_subnet
  user_data                   = file("user_data.sh")

  tags = merge({ Name = "Webserver_Public_2" }, var.general_tags)
}

resource "aws_instance" "webserver_private_2" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.sg_private_2_id]
  subnet_id              = var.vpc_2_private_subnet

  tags = merge({ Name = "Webserver_Private_2" }, var.general_tags)
}
