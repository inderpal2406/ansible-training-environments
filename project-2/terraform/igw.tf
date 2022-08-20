# Define internet gateway for access to public internet from within main-vpc.

resource "aws_internet_gateway" "main-vpc-igw" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name      = "main-vpc-igw"
    Env       = "Management"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}
