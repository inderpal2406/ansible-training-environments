# Default route for destination as VPC CIDR and target as local is by default
# added in each route table.

# Route table for public subnet in main-vpc.

resource "aws_route_table" "main-vpc-pubsub-rt" {
  vpc_id = aws_vpc.main-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-vpc-igw.id
  }
  tags = {
    Name      = "main-vpc-pubsub-rt"
    Env       = "Management"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Route table for private subnet in main-vpc.

resource "aws_route_table" "main-vpc-pvtsub-rt" {
  vpc_id = aws_vpc.main-vpc.id
  tags = {
    Name      = "main-vpc-pvtsub-rt"
    Env       = "Management"
    Env       = "Dev"
    Env       = "Test"
    Env       = "Stg"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Route table association for public subnet 1.

resource "aws_route_table_association" "pubsub1-rt-assocn" {
  route_table_id = aws_route_table.main-vpc-pubsub-rt.id
  subnet_id      = aws_subnet.main-vpc-pubsub-01-1a.id
}

# Route table association for private subnet 1.

resource "aws_route_table_association" "pvtsub1-rt-assocn" {
  route_table_id = aws_route_table.main-vpc-pvtsub-rt.id
  subnet_id      = aws_subnet.main-vpc-pvtsub-01-1a.id
}

# Route table association for private subnet 2.

resource "aws_route_table_association" "pvtsub2-rt-assocn" {
  route_table_id = aws_route_table.main-vpc-pvtsub-rt.id
  subnet_id      = aws_subnet.main-vpc-pvtsub-02-1b.id
}

# Route table association for private subnet 3.

resource "aws_route_table_association" "pvtsub3-rt-assocn" {
  route_table_id = aws_route_table.main-vpc-pvtsub-rt.id
  subnet_id      = aws_subnet.main-vpc-pvtsub-03-1c.id
}

# Route table association for private subnet 4.

resource "aws_route_table_association" "pvtsub4-rt-assocn" {
  route_table_id = aws_route_table.main-vpc-pvtsub-rt.id
  subnet_id      = aws_subnet.main-vpc-pvtsub-04-1c.id
}
