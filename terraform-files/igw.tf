# Define internet gateway for VPC.

resource "aws_internet_gateway" "main-vpc-igw" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name      = "main-vpc-igw"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}