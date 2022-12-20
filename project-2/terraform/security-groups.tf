# Note: In cidr blocks, TF vars are mentioned. Two reasons for this,
# 1. Since, few resources like EC2 instances are not created yet and so cannot
# refer to their exported values.
# 2. If we refer to exported values, then at times it gives cyclic error due to dependencies.
# In my sense, better to refer to vars, as mostly security groups would be created before EC2
# instances so that SG ids can be supplied in EC2 parameters afterwards.

# Security group to allow SSH traffic from public internet.

resource "aws_security_group" "allow-public-ssh" {
  name        = "allow-public-ssh"
  description = "Allow SSH traffic from public internet."
  vpc_id      = aws_vpc.main-vpc.id
  ingress {
    description = "Allow incoming SSH traffic from anywhere on public internet."
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
    Env       = "Management"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Security group to allow RDP traffic from public internet.

resource "aws_security_group" "allow-public-rdp" {
  name        = "allow-public-rdp"
  description = "Allow RDP traffic from public internet."
  vpc_id      = aws_vpc.main-vpc.id
  ingress {
    description = "Allow incoming RDP traffic from anywhere on public internet."
    from_port   = 3389
    to_port     = 3389
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
    Name      = "allow-public-rdp"
    Env       = "Management"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Security group to allow SSH traffic from pubjump host.

resource "aws_security_group" "allow-pubjump-ssh" {
  name        = "allow-pubjump-ssh"
  description = "Allow SSH traffic from pubjump host."
  vpc_id      = aws_vpc.main-vpc.id
  ingress {
    description = "Allow incoming SSH traffic from pubjump host."
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.pubjump-pvt-ip}/32"]
  }
  egress {
    description = "Allow all outgoing traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name      = "allow-pubjump-ssh"
    Env       = "Management"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Security group to allow SSH traffic from pvtjump host.

resource "aws_security_group" "allow-pvtjump-ssh" {
  name        = "allow-pvtjump-ssh"
  description = "Allow SSH traffic from pvtjump host."
  vpc_id      = aws_vpc.main-vpc.id
  ingress {
    description = "Allow incoming SSH traffic from pvtjump host."
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.pvtjump-pvt-ip}/32"]
  }
  egress {
    description = "Allow all outgoing traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name      = "allow-pvtjump-ssh"
    Env       = "Management"
    Env       = "Dev"
    Env       = "Test"
    Env       = "Stg"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Security group to allow SSH traffic from pubans host.

resource "aws_security_group" "allow-pubans-ssh" {
  name        = "allow-pubans-ssh"
  description = "Allow SSH traffic from pubans host."
  vpc_id      = aws_vpc.main-vpc.id
  ingress {
    description = "Allow incoming SSH traffic from pubans host."
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.pubans-pvt-ip}/32"]
  }
  egress {
    description = "Allow all outgoing traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name      = "allow-pubans-ssh"
    Env       = "Management"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Security group to allow WinRM traffic from pubans host.

resource "aws_security_group" "allow-pubans-winrm" {
  name        = "allow-pubans-winrm"
  description = "Allow WinRM traffic from pubans host."
  vpc_id      = aws_vpc.main-vpc.id
  ingress {
    description = "Allow incoming WinRM traffic from pubans host."
    from_port   = 5985
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = ["${var.pubans-pvt-ip}/32"]
  }
  egress {
    description = "Allow all outgoing traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name      = "allow-pubans-winrm"
    Env       = "Management"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Security group to allow SSH traffic from pubans host.

resource "aws_security_group" "allow-pvtans-ssh" {
  name        = "allow-pvtans-ssh"
  description = "Allow SSH traffic from pvtans host."
  vpc_id      = aws_vpc.main-vpc.id
  ingress {
    description = "Allow incoming SSH traffic from pvtans host."
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.pvtans-pvt-ip}/32"]
  }
  egress {
    description = "Allow all outgoing traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name      = "allow-pvtans-ssh"
    Env       = "Management"
    Env       = "Dev"
    Env       = "Test"
    Env       = "Stg"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Security group to allow proxy traffic from all hosts.

resource "aws_security_group" "allow-proxy-traffic" {
  name        = "allow-proxy-traffic"
  description = "Allow proxy traffic from all hosts."
  vpc_id      = aws_vpc.main-vpc.id
  ingress {
    description = "Allow incoming proxy traffic from all hosts."
    from_port   = 3128
    to_port     = 3128
    protocol    = "tcp"
    cidr_blocks = ["${var.main-vpc-cidr}"]
  }
  egress {
    description = "Allow all outgoing traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name      = "allow-proxy-traffic"
    Env       = "Management"
    Env       = "Dev"
    Env       = "Test"
    Env       = "Stg"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Security group for Dev environment.

resource "aws_security_group" "dev-sg" {
  name        = "dev-sg"
  description = "Allow web & db traffic in dev environment."
  vpc_id      = aws_vpc.main-vpc.id
  ingress {
    description = "Allow incoming web traffic from all hosts in dev environment."
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.main-vpc-pvtsub-02-1b-cidr}"]
  }
  ingress {
    description = "Allow incoming db traffic from all hosts in dev environment."
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.main-vpc-pvtsub-02-1b-cidr}"]
  }
  egress {
    description = "Allow all outgoing traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name      = "dev-sg"
    Env       = "Dev"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Security group for Test environment.

resource "aws_security_group" "test-sg" {
  name        = "test-sg"
  description = "Allow web & db traffic in test environment."
  vpc_id      = aws_vpc.main-vpc.id
  ingress {
    description = "Allow incoming web traffic from all hosts in test environment."
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.main-vpc-pvtsub-03-1c-cidr}"]
  }
  ingress {
    description = "Allow incoming db traffic from all hosts in test environment."
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.main-vpc-pvtsub-03-1c-cidr}"]
  }
  egress {
    description = "Allow all outgoing traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name      = "test-sg"
    Env       = "Test"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Security group for Test environment.

resource "aws_security_group" "stg-sg" {
  name        = "stg-sg"
  description = "Allow web & db traffic in staging environment."
  vpc_id      = aws_vpc.main-vpc.id
  ingress {
    description = "Allow incoming web traffic from all hosts in staging environment."
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.main-vpc-pvtsub-04-1c-cidr}"]
  }
  ingress {
    description = "Allow incoming db traffic from all hosts in test environment."
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.main-vpc-pvtsub-04-1c-cidr}"]
  }
  egress {
    description = "Allow all outgoing traffic."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name      = "stg-sg"
    Env       = "Stg"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}
