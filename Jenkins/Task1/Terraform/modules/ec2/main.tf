resource "aws_instance" "webserver_public_1" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = var.aws_instance_associate_public_address
  vpc_security_group_ids      = [var.sg_public_1_id]
  subnet_id                   = var.vpc_1_public_subnet
  user_data                   = file("${path.module}/files/user_data_main.sh")

  tags = merge(var.general_tags, { Name = "Jenkins_main" })
}

resource "aws_instance" "webserver_public_2" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = var.aws_instance_associate_public_address
  vpc_security_group_ids      = [var.sg_public_1_id]
  subnet_id                   = var.vpc_1_public_subnet
  user_data                   = file("${path.module}/files/user_data_node.sh")

  tags = merge(var.general_tags, { Name = "Jenkins_node" })
}