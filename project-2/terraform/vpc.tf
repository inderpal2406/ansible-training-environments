# Define main vpc.

resource "aws_vpc" "main-vpc" {
  cidr_block = var.main-vpc-cidr
  # Let instance tenancy be decided by EC2 instance configuration during launch.
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = false
  tags = {
    Name      = "main-vpc"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}
