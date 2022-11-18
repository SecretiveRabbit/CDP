output "jenkins_main_ip" {
  value = aws_instance.webserver_public_1.public_ip
}
output "jenkins_node_ip" {
  value = aws_instance.webserver_public_2.public_ip
}