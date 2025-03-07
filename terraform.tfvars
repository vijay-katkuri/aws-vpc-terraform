aws_region  = "eu-south-1"
vpc_name    = "vkatkuri-lab"
vpc_cidr    = "10.0.1.0/24"
number_of_subnets       = 6
create_private_subnets  = true
create_public_subnets   = true
create_nat_gateway      = true




#--------------------------------------------------------------
# Tags common to all resources
#--------------------------------------------------------------
default_tags = {
  Environment   = "PROD"
  Owner         = "vkatkuri"
  "Expiry Days" = "365" 

}