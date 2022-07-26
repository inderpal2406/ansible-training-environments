# Define EC2 instances.

# Before creating EC2 instance, have the security group and key-pair ready beforehand.

# Define private IP addresses of hosts as local values.

locals {
  bastion-server-pvt-ip = "10.0.0.4"
}

# Bastion server.

resource "aws_instance" "bastion-server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.bastion-server-key.key_name
  subnet_id                   = aws_subnet.main-vpc-pub-subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow-public-ssh.id]
  private_ip                  = local.bastion-server-pvt-ip
  tenancy                     = "default" # shared.
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required" # Enables IMDSv2 service only.
  }
  # By default private IP based hostname is setup always with a corresponding pvt DNS entry.
  #private_dns_name_options {}
  tags = {
    Name      = "bastion-server"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
  user_data = <<EOF
    #!/usr/bin/env bash
    machine_name="bastion-server"
    sudo hostnamectl set-hostname $machine_name
    sudo echo "${local.bastion-server-pvt-ip} $machine_name" >> /etc/hosts 
    EOF
}

