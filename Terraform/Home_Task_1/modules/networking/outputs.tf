output "sg_public_1_id" {
  value = aws_security_group.sg_public.id
}
output "sg_private_1_id" {
  value = aws_security_group.sg_private.id
}
output "sg_public_2_id" {
  value = aws_security_group.sg_public_2.id
}
output "sg_private_2_id" {
  value = aws_security_group.sg_private_2.id
}
output "vpc_1_public_subnet" {
  value = aws_subnet.public_subnet_1.id
}
output "vpc_1_private_subnet" {
  value = aws_subnet.private_subnet_1.id
}
output "vpc_2_public_subnet" {
  value = aws_subnet.public_subnet_2.id
}
output "vpc_2_private_subnet" {
  value = aws_subnet.private_subnet_2.id
}