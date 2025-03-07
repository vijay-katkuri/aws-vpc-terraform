# variables.tf ~ Defines global vars for the project

############################################
## AWS ACCOUNT RELATED VARIABLES
############################################

variable "aws_region" {
  description = "(Required) The AWS Region where resources will be created"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "number_of_subnets" {
  description = "Number of subnets to create"
  type        = number
}

variable "create_private_subnets" {
  description = "Whether to create private subnets"
  type        = bool
}

variable "create_public_subnets" {
  description = "Whether to include public subnets"
  type        = bool
}

variable "create_nat_gateway" {
  description = "Whether to include NAT gateway. This Nat will be used in route table of private"
  type        = bool
}

variable "default_tags" {
  description = "(Required) Tags to all resources. This is environment specific."
  type        = map(string)
}