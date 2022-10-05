
/*
output "sg_public_1_id" {
  value = aws_security_group.sg_public.id
}
output "sg_private_1_id" {
  value = aws_security_group.sg_private.id
}*/
output "vpc_1_public_subnet" {
  value = aws_subnet.public_subnet_1.id
}
output "vpc_1_private_subnet" {
  value = aws_subnet.private_subnet_1.id
}
output "vpc_1_public_subnet_2" {
  value = aws_subnet.public_subnet_2.id
}
output "vpc_1_private_subnet_2" {
  value = aws_subnet.private_subnet_2.id
} /*
output "alb_sg" {
  value = aws_security_group.alb.id
}*/
output "vpc_id" {
  value = aws_vpc.vpc_1.id
}
output "nat_gtw_1" {
  value = aws_nat_gateway.nat_gtw_1
}