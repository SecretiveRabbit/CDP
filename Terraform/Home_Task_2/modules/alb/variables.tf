variable "public_subnet_1_id" {}
variable "public_subnet_2_id" {}
variable "vpc_id" {}
variable "asg_id" {}
variable "alb_target_port" {}
variable "alb_tg_protocol" {
  default = "HTTP"
}
variable "healthy_threshold" {
  type    = number
  default = 5
}
variable "unhealthy_threshold" {
  type    = number
  default = 2
}
variable "interval" {
  type    = number
  default = 60
}
variable "listener_protocol" {
  type    = string
  default = "HTTP"
}
variable "listener_port" {
  type    = string
  default = "80"
}
variable "ingress_from_port" {
  type    = number
  default = 80
}
variable "ingress_to_port" {
  type    = number
  default = 80
}
variable "egress_from_port" {
  type    = number
  default = 0
}
variable "egress_to_port" {
  type    = number
  default = 0
}