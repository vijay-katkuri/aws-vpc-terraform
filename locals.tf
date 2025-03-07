locals {
  # Calculate the number of bits needed to create the required number of subnets
  subnet_bits = ceil(log(var.number_of_subnets, 2))
  public_subnets = var.create_public_subnets ? ceil(var.number_of_subnets / 2) : 0
  private_subnets = var.create_private_subnets ? var.number_of_subnets - local.public_subnets : 0
  
  # Generate the subnet CIDR blocks
  subnet_cidr_blocks = [for i in range(var.number_of_subnets) : cidrsubnet(var.vpc_cidr, local.subnet_bits, i)]
  
  public_cidr = slice(local.subnet_cidr_blocks,0,local.public_subnets)
  private_cidr = slice(local.subnet_cidr_blocks,local.public_subnets,var.number_of_subnets)

  # Generate availability zone names based on the region
  az_suffixes = ["a", "b", "c"]
  az_names = [for suffix in local.az_suffixes : format("%s%s", data.aws_region.current.name, suffix)]
}