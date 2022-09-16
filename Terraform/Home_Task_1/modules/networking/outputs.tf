output "Webserver-Public-IP" {
  value = aws_instance.webserver_public_1.public_ip
}
output "Webserver-Public-IP-2" {
  value = aws_instance.webserver_public_2.public_ip
}
output "VPC_1_EC2_Private_IP" {
  value = aws_instance.webserver_private_1.private_ip
}
output "VPC_2_EC2_Private_IP" {
  value = aws_instance.webserver_private_2.private_ip
}