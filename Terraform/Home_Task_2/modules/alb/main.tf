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
  port     = var.alb_target_port
  protocol = var.alb_tg_protocol
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    interval            = var.interval
  }
}

resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    target_group_arn = aws_alb_target_group.this_tg.arn
    type             = "forward"
  }
}

resource "aws_security_group" "alb" {
  name        = "terraform_alb_security_group"
  description = "Terraform load balancer security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.ingress_from_port
    to_port     = var.ingress_to_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = var.egress_from_port
    to_port     = var.egress_to_port
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}