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
  user_data       = file("${path.module}/user_data.sh")
  security_groups = [aws_security_group.sg_private.id]

  depends_on = [var.nat_gtw_1]
}

resource "aws_autoscaling_policy" "asg_policy" {
  name                   = "asg_policy_terraform"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.this_asg.name
}

resource "aws_autoscaling_group" "this_asg" {
  name                 = "asg"
  launch_configuration = aws_launch_configuration.asg_lc.name
  min_size             = 2
  max_size             = 4
  desired_capacity     = 2
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
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
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
  vpc_id = var.vpc_id

  ingress {
    protocol = "tcp"
    #cidr_blocks = ["0.0.0.0/0"] #["10.0.1.0/24"]
    security_groups = [aws_security_group.sg_public.id]
    from_port       = 80
    to_port         = 80
  }
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [var.alb_sg]
  }
  egress {
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }
}