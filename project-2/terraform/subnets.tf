# Public subnet in ap-south-1a AZ for management purpose.
# Public subnet is one which can reach out to public internet.
# This means, it has a route to IGW in its route table.

resource "aws_subnet" "main-vpc-pubsub-01-1a" {
  vpc_id                  = aws_vpc.main-vpc.id
  availability_zone       = "ap-south-1a"
  cidr_block              = var.main-vpc-pubsub-01-1a-cidr
  map_public_ip_on_launch = false # Don't want to assign public IP to all instances.
  # Public IP for required instance would be associated in instamce configuration.
  tags = {
    Name      = "main-vpc-pubsub-01-1a"
    Env       = "Management"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Private subnet in ap-south-1a AZ for management purpose.

resource "aws_subnet" "main-vpc-pvtsub-01-1a" {
  vpc_id                  = aws_vpc.main-vpc.id
  availability_zone       = "ap-south-1a"
  cidr_block              = var.main-vpc-pvtsub-01-1a-cidr
  map_public_ip_on_launch = false
  tags = {
    Name      = "main-vpc-pvtsub-01-1a"
    Env       = "Management"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Private subnet in ap-south-1b AZ for dev environment.

resource "aws_subnet" "main-vpc-pvtsub-02-1b" {
  vpc_id                  = aws_vpc.main-vpc.id
  availability_zone       = "ap-south-1b"
  cidr_block              = var.main-vpc-pvtsub-02-1b-cidr
  map_public_ip_on_launch = false
  tags = {
    Name      = "main-vpc-pvtsub-02-1b"
    Env       = "Dev"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Private subnet in ap-south-1c AZ for test environment.

resource "aws_subnet" "main-vpc-pvtsub-03-1c" {
  vpc_id                  = aws_vpc.main-vpc.id
  availability_zone       = "ap-south-1c"
  cidr_block              = var.main-vpc-pvtsub-03-1c-cidr
  map_public_ip_on_launch = false
  tags = {
    Name      = "main-vpc-pvtsub-03-1c"
    Env       = "Test"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Private subnet in ap-south-1c AZ for staging environment.

resource "aws_subnet" "main-vpc-pvtsub-04-1c" {
  vpc_id                  = aws_vpc.main-vpc.id
  availability_zone       = "ap-south-1c"
  cidr_block              = var.main-vpc-pvtsub-04-1c-cidr
  map_public_ip_on_launch = false
  tags = {
    Name      = "main-vpc-pvtsub-04-1c"
    Env       = "Stg"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}
