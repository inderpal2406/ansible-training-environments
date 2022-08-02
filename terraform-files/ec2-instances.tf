# Define EC2 instances.

# Before creating EC2 instance, have the security group and key-pair ready beforehand.

# Define private IP addresses of hosts as local values. Commented as these are not being used anymore in our file.
/*
locals {
  bastion-server-pvt-ip   = "10.0.0.4"
  bastion-server-hostname = "bastion-server"
  ansible-server-pvt-ip   = "10.0.1.4"
  ansible-server-hostname = "ansible-server"
}
*/
# Bastion server.

resource "aws_instance" "bastion-server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.bastion-server-key.key_name
  subnet_id                   = aws_subnet.main-vpc-pub-subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow-public-ssh.id]
  private_ip                  = var.bastion-server-pvt-ip
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
  # We don't use user_data in below format as we wanted flexibility to change hostname & Ip address via variables,
  # and it was not happening with use of locals in below format.
  /*
  user_data = <<EOF
    #!/bin/bash
    sudo hostnamectl set-hostname "${local.bastion-server-hostname}"
    sudo echo "${local.bastion-server-pvt-ip} ${local.bastion-server-hostname}" >> /etc/hosts
    sudo echo "${local.ansible-server-pvt-ip} ${local.ansible-server-hostname}" >> /etc/hosts
    EOF
  */
  # Below format of user_data requires template provider which has been archived by Hashicorp.
  # Hashicorp now suggests to use templatefile() or cloudinit provider instead.
  /*
  user_data = data.template_file.bastion-server-init.rendered
  */
  # Below user_data fails if I split the path & variables in multiple lines.
  # The hostname and hosts entry doesn't get setup.
  /*
  user_data = templatefile(
    ".\\template-files\\bastion-server-init.sh.tftpl",
    {
      bastion_server_pvt_ip   = var.bastion-server-pvt-ip,
      bastion_server_hostname = "bastion-server",
      ansible_server_pvt_ip   = var.ansible-server-pvt-ip,
      ansible_server_hostname = var.ansible-server-hostname
    }
  )
  */
  # So, we mention user_data in single line.
  user_data = templatefile(".\\template-files\\bastion-server-init.sh.tftpl", { bastion_server_hostname = var.bastion-server-hostname, bastion_server_pvt_ip = var.bastion-server-pvt-ip, ansible_server_hostname = var.ansible-server-hostname, ansible_server_pvt_ip = var.ansible-server-pvt-ip, squid_proxy_hostname = var.squid-proxy-hostname, squid_proxy_pvt_ip = var.squid-proxy-pvt-ip })
  # Copy private key to ssh to ansible-server from bastion-server.
  provisioner "file" {
    source      = "ssh-keys\\ansible-server-key"
    destination = "/tmp/id_rsa"
  }
  # ~/.ssh directory already exists, so we don't create it in remote-exec.
  provisioner "remote-exec" {
    inline = [
      "mv /tmp/id_rsa ~/.ssh/",
      "chmod 600 ~/.ssh/id_rsa"
    ]
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(".\\ssh-keys\\bastion-server-key")
    host        = aws_instance.bastion-server.public_ip
  }
}

# Ansible server on Ubuntu.

resource "aws_instance" "ansible-server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ansible-server-key.id
  subnet_id                   = aws_subnet.main-vpc-pvt-subnet.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.allow-bastion-ssh.id]
  private_ip                  = var.ansible-server-pvt-ip
  tenancy                     = "default"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name      = "ansible-server"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
  user_data = templatefile(".\\template-files\\ansible-server-init.sh.tftpl", { ansible_server_hostname = var.ansible-server-hostname, ansible_server_pvt_ip = var.ansible-server-pvt-ip, squid_proxy_hostname = var.squid-proxy-hostname, squid_proxy_pvt_ip = var.squid-proxy-pvt-ip })
}

# Squid proxy server.

resource "aws_instance" "squid-proxy" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ansible-server-key.key_name
  subnet_id                   = aws_subnet.main-vpc-pub-subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow-bastion-ssh.id, aws_security_group.allow-proxy-traffic.id]
  private_ip                  = var.squid-proxy-pvt-ip
  tenancy                     = "default"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name      = var.squid-proxy-hostname
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
  user_data = templatefile(".\\template-files\\squid-proxy-init.sh.tftpl", { squid_proxy_hostname = var.squid-proxy-hostname, squid_proxy_pvt_ip = var.squid-proxy-pvt-ip })
}

resource "aws_instance" "ubuntu10" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ansible-server-key.key_name
  subnet_id                   = aws_subnet.main-vpc-pvt-subnet.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.allow-ansible-ssh.id]
  private_ip                  = var.ubuntu10-pvt-ip
  tenancy                     = "default"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name      = var.ubuntu10-hostname
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
  user_data = templatefile(".\\template-files\\ubuntu10-init.sh.tftpl", { ubuntu10_hostname = var.ubuntu10-hostname, ubuntu10_pvt_ip = var.ubuntu10-pvt-ip })
}

# test-server created to test using which user is the user_data executed.
# But no file such as /tmp/whoami.txt got created to get an answer.
/*
resource "aws_instance" "test-server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ansible-server-key.key_name
  subnet_id                   = aws_subnet.main-vpc-pvt-subnet.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.allow-bastion-ssh.id]
  private_ip                  = "10.0.1.5"
  tenancy                     = "default"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name      = "test-server"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
  user_data = <<EOF
  #!/usr/bin/env bash
  whoami >> /tmp/whoami.txt
  EOF
}
*/
