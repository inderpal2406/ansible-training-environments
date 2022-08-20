# Create public subnet in main-vpc of ap-south-1 region.

resource "aws_subnet" "main-vpc-pub-subnet" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.public-subnet-cidr
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
  tags = {
    Name      = "main-vpc-pub-subnet"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# The default NACL & main RT gets associated with above subnet automatically.

resource "aws_subnet" "main-vpc-pvt-subnet" {
  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = var.private-subnet-cidr
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false
  tags = {
    Name      = "main-vpc-pvt-subnet"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}