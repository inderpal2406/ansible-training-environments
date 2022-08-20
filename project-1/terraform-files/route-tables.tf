# Define route table for public subnet.

resource "aws_route_table" "main-vpc-pub-subnet-rt" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-vpc-igw.id
  }
  # The default route, mapping the VPC's CIDR block to "local", is created implicitly and cannot be specified.
  tags = {
    Name      = "main-vpc-pub-subnet-rt"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Associate above route table with public subnet.

resource "aws_route_table_association" "pub-subnet-rt-assocn" {
  subnet_id      = aws_subnet.main-vpc-pub-subnet.id
  route_table_id = aws_route_table.main-vpc-pub-subnet-rt.id
}

# Define route table for private subnet.

resource "aws_route_table" "main-vpc-pvt-subnet-rt" {
  vpc_id = aws_vpc.main-vpc.id
  # No route block as the default route for VPC CIDR will get automatically created by default.
  tags = {
    Name      = "main-vpc-pvt-subnet-rt"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Associate above route table with private subnet.

resource "aws_route_table_association" "pvt-subnet-rt-assocn" {
  subnet_id      = aws_subnet.main-vpc-pvt-subnet.id
  route_table_id = aws_route_table.main-vpc-pvt-subnet-rt.id
}
