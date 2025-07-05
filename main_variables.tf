provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[0].id
  depends_on    = [aws_internet_gateway.igw]
}

locals {
  public_subnets = [
    for i in range(var.public_subnet_count) : {
      name = "public-${i + 1}"
      cidr = cidrsubnet(var.vpc_cidr, 8, i)
      az   = element(var.azs, i % length(var.azs))
    }
  ]

  private_subnets = [
    for i in range(var.private_subnet_count) : {
      name = "private-${i + 1}"
      cidr = cidrsubnet(var.vpc_cidr, 8, i + var.public_subnet_count)
      az   = element(var.azs, i % length(var.azs))
    }
  ]
}

resource "aws_subnet" "public" {
  for_each = { for subnet in local.public_subnets : subnet.name => subnet }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = { Name = each.key }
}

resource "aws_subnet" "private" {
  for_each = { for subnet in local.private_subnets : subnet.name => subnet }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = { Name = each.key }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "ec2_sg" {
  name   = "ec2-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
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

locals {
  subnet_list = var.ec2_subnet_type == "public" ? values(aws_subnet.public) : values(aws_subnet.private)
}

resource "aws_instance" "bulk_instances" {
  count                       = var.ec2_instance_count
  ami                         = var.ec2_ami
  instance_type               = var.ec2_instance_type
  key_name                    = "princemittal" 
  subnet_id                   = local.subnet_list[count.index % length(local.subnet_list)].id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = var.ec2_subnet_type == "public" ? true : false

  tags = {
    Name = "ec2-${count.index + 1}"
  }
}