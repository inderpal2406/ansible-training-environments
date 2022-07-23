# Define security groups for EC2 instances.

resource "aws_security_group" "allow-public-ssh" {
  name        = "allow-public-ssh"
  description = "Allow SSH traffic from public internet."
  vpc_id      = aws_vpc.main-vpc.id
  ingress {
    description = "Allow SSH traffic from everywhere on public internet."
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all outgoing traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name      = "allow-public-ssh"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

resource "aws_security_group" "allow-bastion-ssh" {
  name        = "allow-bastion-ssh"
  description = "Allow SSH traffic from bastion host."
  vpc_id      = aws_vpc.main-vpc.id
  ingress {
    description = "Allow incoming SSH traffic from bastion host."
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all outgoing traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow-bastion-ssh"
    Terraform = "True"
    Owner = "Vikram Singh"
  }
}