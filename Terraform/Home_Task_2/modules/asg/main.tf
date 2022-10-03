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

resource "aws_launch_configuration" "asg_lc" {
  name_prefix       = "terraform_lc"
  image_id          = data.aws_ami.amazon-linux-2.id
  instance_type     = "t2.micro"
  key_name          = "TEST"
  user_data         = file("user_data.sh")
  placement_tenancy = "default"
  security_groups   = [var.sg_public_1_id]

  lifecycle {
    create_before_destroy = true
  }
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
  #availability_zones = ["us-east-1a"]
  target_group_arns = [aws_alb_target_group.this_tg.arn]

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns] #[aws_lb.alb.arn, aws_alb_target_group.this_tg.arn]
  }
  depends_on = [aws_lb.alb]
}

#-------------------------------------application load balancer---------------------------------------
resource "aws_lb" "alb" {
  name               = "lb-terraform"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = [var.alb_sg]
  subnets            = [var.public_subnet_1_id, var.public_subnet_2_id]

  enable_deletion_protection = false
  /*
  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }
*/
  tags = {
    Environment = "production"
    Name        = "alb"
  }
}

resource "aws_alb_target_group" "this_tg" {
  name        = "terraform-alb-target"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
  stickiness {
    type = "lb_cookie"
  }
  health_check {
    path                = "/index.html"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.this_tg.arn
    type             = "forward"
  }
} /*
resource "aws_lb_target_group_attachment" "ec2_attach" {
  target_group_arn = aws_alb_target_group.this_tg.arn
  target_id        = aws_autoscaling_group.this_asg.id # what to set? alb_arn
}*/

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.this_asg.id
  lb_target_group_arn    = aws_alb_target_group.this_tg.arn
}


