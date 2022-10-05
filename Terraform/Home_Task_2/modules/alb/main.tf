#-------------------------------------application load balancer---------------------------------------
resource "aws_lb" "alb" {
  name               = "lb-terraform"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [var.public_subnet_1_id, var.public_subnet_2_id]

  tags = {
    Environment = "production"
    Name        = "alb"
  }
}

resource "aws_alb_target_group" "this_tg" {
  name     = "terraform-alb-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  #target_type = "instance" #default

  health_check {
    #path                = "/index.html"
    #port                = 80
    #protocol            = "HTTP"
    #timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 60
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
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = var.asg_id
  lb_target_group_arn    = aws_alb_target_group.this_tg.arn
}

resource "aws_security_group" "alb" {
  name        = "terraform_alb_security_group"
  description = "Terraform load balancer security group"
  vpc_id      = var.vpc_id
  /*
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }*/

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}