output "sg_public_1_id" {
  value = aws_security_group.sg_public.id
}
output "vpc_1_public_subnet" {
  value = aws_subnet.public_subnet_1.id
}