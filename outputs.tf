output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnets" {
  value = [for s in aws_subnet.private : s.id]
}

output "ec2_ids" {
  value = [for inst in aws_instance.bulk_instances : inst.id]
}

output "ec2_names" {
  value = [for inst in aws_instance.bulk_instances : inst.tags["Name"]]
}
