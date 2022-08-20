# Key-pair to login to hosts in main-vpc-pubsub-01-1a subnet.

resource "aws_key_pair" "main-vpc-pubsub-01-1a-key" {
  key_name   = "main-vpc-pubsub-01-1a-key"
  public_key = file(".\\ssh-keys\\main-vpc-pubsub-01-1a-key.pub")
  tags = {
    Name      = "main-vpc-pubsub-01-1a-key"
    Env       = "Management"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Key-pair to login to hosts in main-vpc-pvtsub-01-1a subnet.

resource "aws_key_pair" "main-vpc-pvtsub-01-1a-key" {
  key_name   = "main-vpc-pvtsub-01-1a-key"
  public_key = file(".\\ssh-keys\\main-vpc-pvtsub-01-1a-key.pub")
  tags = {
    Name      = "main-vpc-pvtsub-01-1a-key"
    Env       = "Management"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Key-pair to login to hosts in main-vpc-pvtsub-02-1b subnet.

resource "aws_key_pair" "main-vpc-pvtsub-02-1b-key" {
  key_name   = "main-vpc-pvtsub-02-1b-key"
  public_key = file(".\\ssh-keys\\main-vpc-pvtsub-02-1b-key.pub")
  tags = {
    Name      = "main-vpc-pvtsub-02-1b-key"
    Env       = "Dev"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Key-pair to login to hosts in main-vpc-pvtsub-03-1c subnet.

resource "aws_key_pair" "main-vpc-pvtsub-03-1c-key" {
  key_name   = "main-vpc-pvtsub-03-1c-key"
  public_key = file(".\\ssh-keys\\main-vpc-pvtsub-03-1c-key.pub")
  tags = {
    Name      = "main-vpc-pvtsub-03-1c-key"
    Env       = "Test"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}

# Key-pair to login to hosts in main-vpc-pvtsub-04-1c subnet.

resource "aws_key_pair" "main-vpc-pvtsub-04-1c-key" {
  key_name   = "main-vpc-pvtsub-04-1c-key"
  public_key = file(".\\ssh-keys\\main-vpc-pvtsub-04-1c-key.pub")
  tags = {
    Name      = "main-vpc-pvtsub-04-1c-key"
    Env       = "Stg"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}
