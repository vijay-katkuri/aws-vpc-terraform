output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private_subnets[*].id
}

output "private_route_table_id" {
  description = "The private route table id which can be used in another resources"
  value = aws_route_table.private_route_table.id
  
}
output "vpc_CIDR" {
  description = "The cidr of the created vpc"
  value = aws_vpc.main.cidr_block
  
}


output "vpc_summary" {
  description = "Summary of the created VPC and its associated resources"
  value = <<EOT
    VPC "${aws_vpc.main.tags["Name"]}" created with associated CIDR block "${aws_vpc.main.cidr_block}":
      - Contains ${length(aws_subnet.public_subnets) + length(aws_subnet.private_subnets)} subnets,
        in which ${length(aws_subnet.public_subnets)} are public and ${length(aws_subnet.private_subnets)} are private.
      - Public Subnets:
          ${join("\n", formatlist("      - %s ---- %s (%s)", aws_subnet.public_subnets[*].id, aws_subnet.public_subnets[*].cidr_block, aws_subnet.public_subnets[*].availability_zone))}
      - Private Subnets:
          ${join("\n", formatlist("      - %s ---- %s (%s)", aws_subnet.private_subnets[*].id, aws_subnet.private_subnets[*].cidr_block, aws_subnet.private_subnets[*].availability_zone))}
      - Internet Gateway: ${aws_internet_gateway.igw.id}
      - NAT Gateway: ${var.create_nat_gateway ? aws_nat_gateway.nat_gateway[0].id : "None"}
      - Private Route Table: ${aws_route_table.private_route_table.id}
      - Public Route Table: ${aws_route_table.public_route_table.id}
  EOT
}