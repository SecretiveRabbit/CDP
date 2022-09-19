output "SG_Public_1_id" {
  value = aws_security_group.sg_public.id
}
output "SG_Private_1_id" {
  value = aws_security_group.sg_private.id
}
output "SG_Public_2_id" {
  value = aws_security_group.sg_public_2.id
}
output "SG_Private_2_id" {
  value = aws_security_group.sg_private_2.id
}
output "VPC_1_Public_Subnet" {
  value = aws_subnet.Public_subnet_1.id
}
output "VPC_1_Private_Subnet" {
  value = aws_subnet.Private_subnet_1.id
}
output "VPC_2_Public_Subnet" {
  value = aws_subnet.Public_subnet_2.id
}
output "VPC_2_Private_Subnet" {
  value = aws_subnet.Private_subnet_2.id
}
