# Data source to get ubuntu AMI ID (ami-068257025f72f470d) in ap-south-1 region.

data "aws_ami" "ubuntu-ami-id" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220609"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Data source to get redhat AMI ID (ami-05c8ca4485f8b138a) in ap-south-1 region.

data "aws_ami" "redhat-ami-id" {
  most_recent = true
  owners      = ["309956199498"] # Redhat (not sure)
  filter {
    name   = "name"
    values = ["RHEL-8.6.0_HVM-20220503-x86_64-2-Hourly2-GP2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Data source to get Microsoft Windows AMI ID (ami-0de07eb85c12b8dbb) in ap-south-1 region.

data "aws_ami" "windows-ami-id" {
  most_recent = true
  owners      = ["801119661308"]
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-2022.12.14"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
