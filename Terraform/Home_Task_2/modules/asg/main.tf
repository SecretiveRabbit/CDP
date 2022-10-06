data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

}

data "aws_ssm_parameter" "key_pair" {
  name = "TEST"
}

resource "aws_launch_configuration" "asg_lc" {
  name_prefix     = "terraform_lc"
  image_id        = data.aws_ami.amazon-linux-2.id
  instance_type   = "t2.micro"
  key_name        = data.aws_ssm_parameter.key_pair.name
  user_data       = file("${path.module}/files/user_data.sh")
  security_groups = [aws_security_group.sg_private.id]

  depends_on = [var.nat_gtw_1]
}

resource "aws_autoscaling_policy" "asg_policy" {
  name                   = "asg_policy_terraform"
  scaling_adjustment     = var.asg_scaling_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.asg_cooldown
  autoscaling_group_name = aws_autoscaling_group.this_asg.name
}

resource "aws_autoscaling_group" "this_asg" {
  name                 = "asg"
  launch_configuration = aws_launch_configuration.asg_lc.name
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  desired_capacity     = var.asg_desired_capacity
  vpc_zone_identifier  = [var.private_subnet_1_id, var.private_subnet_2_id]
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.this_asg.id
  lb_target_group_arn    = var.tg_arn
}

resource "aws_security_group" "sg_public" {
  name   = "sg_pub_1"
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    cidr_blocks = var.pub_sg_cidr_for_asg
    from_port   = var.pub_sg_ingress_from_port
    to_port     = var.pub_sg_ingress_to_port
  }
  egress {
    protocol    = "-1"
    cidr_blocks = var.pub_sg_cidr_for_asg
    from_port   = var.pub_sg_egress_from_port
    to_port     = var.pub_sg_egress_to_port
  }
}

resource "aws_security_group" "sg_private" {
  name   = "sg_priv_1"
  vpc_id = var.vpc_id

  ingress {
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_public.id, var.alb_sg]
    from_port       = var.priv_sg_ingress_from_port
    to_port         = var.priv_sg_ingress_to_port
  }
  egress {
    protocol    = "-1"
    cidr_blocks = var.priv_sg_cidr_for_asg
    from_port   = var.priv_sg_egress_from_port
    to_port     = var.priv_sg_egress_to_port
  }
}