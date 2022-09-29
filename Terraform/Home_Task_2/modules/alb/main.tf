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
  autoscaling_group_name = var.asg_id
  lb_target_group_arn    = aws_alb_target_group.this_tg.arn
}