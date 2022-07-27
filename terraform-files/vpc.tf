# Create custom VPC in ap-south-1 region.

resource "aws_vpc" "main-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true   # This parameter enables resolution of public DNS entries from public DNS servers.
  enable_dns_hostnames = false
  #ipv6_cidr_block = (by default, if we don't specify this attribute, then
  #no ipv6 addresses gets associated)
  tags = {
    Name      = "main-vpc"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Notes: With this VPC, one SG, one RT, one NACL gets created automatically.
# These are referred to as default/main resources for this custom VPC.
# We'll use this automatically created default NACL & RT with our subnets.
# During subnet creation, we won't specify NACL & RT parameters (if any)
# and terraform & AWS should themselves relate default NACL & RT with our subnets.
# In terms of functionality default NACL & RT will server our purpose, as these
# allow all incoming and outgoing & internal VPC routing by default.
# However, we'll leave default SG created. We'll instead create custom SG
# with required details and associate them with EC2 instances.

# After one day, we saw a problem that default RT doesn't has route to IGW to 
# send response traffic of SSH session. So, we'll leave default RT as it is.
# And create 2 RTs, one for public subnet & other for private subnet.
