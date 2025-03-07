
data "aws_region" "current" {}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge( {
    Name = var.vpc_name
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge({
    Name = format("igw-%s", aws_vpc.main.tags["Name"])
  })
}

resource "aws_subnet" "public_subnets" {
  count = var.create_public_subnets ? local.public_subnets : 0
  vpc_id = aws_vpc.main.id
  cidr_block = local.public_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone = element(local.az_names, count.index )

  tags = merge(
    { Name = format("%s-public-subnet-%d%s", var.vpc_name, count.index + 1, substr(element(local.az_names, count.index), -1, 1)) },
    {"subnet_type" = "public"}
  )
}

resource "aws_subnet" "private_subnets" {
  count = var.create_private_subnets ? local.private_subnets : 0
  vpc_id = aws_vpc.main.id
  cidr_block = local.private_cidr[count.index]
  map_public_ip_on_launch = false
  availability_zone = element(local.az_names, count.index)

  tags = merge(
    { Name = format("%s-private-subnet-%d%s", var.vpc_name, count.index + 1, substr(element(local.az_names, count.index), -1, 1)) },
    { "subnet_type" = "private" }
  )
}

resource "aws_eip" "nat_eip" {
  count = var.create_nat_gateway ? 1 : 0
  domain = "vpc"
  tags = merge( {
    Name = format("eip-nat-gateway-%s", aws_vpc.main.id)
  })
}

resource "aws_nat_gateway" "nat_gateway" {
  count = var.create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id = aws_subnet.public_subnets[0].id

  tags = merge( {
    Name = format("nat-gateway-%s", aws_vpc.main.id)
  })
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  dynamic "route" {
    for_each = var.create_nat_gateway ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat_gateway[0].id
    }
  }

  tags = merge({
    Name = format("%s-private-route-table-%s", var.vpc_name, aws_vpc.main.id)
  })
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge({
    Name = format("%s-public-route-table-%s", var.vpc_name, aws_vpc.main.id)
  })
}

resource "aws_route_table_association" "public_associations" {
  count = var.create_public_subnets ? local.public_subnets : 0
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_associations" {
  count = var.create_private_subnets ? local.private_subnets : 0
  subnet_id = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}