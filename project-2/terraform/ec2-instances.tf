# Public jump server (bastion host) on ubuntu.

resource "aws_instance" "pubjump" {
  ami                         = data.aws_ami.ubuntu-ami-id.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.main-vpc-pubsub-01-1a-key.key_name
  subnet_id                   = aws_subnet.main-vpc-pubsub-01-1a.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow-public-ssh.id, aws_security_group.allow-pubans-ssh.id]
  private_ip                  = var.pubjump-pvt-ip
  tenancy                     = "default"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name      = var.pubjump-hostname
    Env       = "Management"
    App       = "Jump Server"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
  user_data = templatefile("template-files\\pubans-ansible-pre-requisites.sh.tftpl", { pubans_ansible_pub_key = var.pubans-ansible-pub-key })
  provisioner "file" {
    source      = "ssh-keys\\pubans-ansible-key"
    destination = "/tmp/id_rsa"
  }
  # The order of execution of user_data & remote-exec may not be fixed.
  # At a time, it is possible that both may run concurrently.
  # Our remote-exec was failing repeatedly by giving error that ansible user doesn't exist.
  # Home dir of ansible doesn't exist.
  # So, we introduced delay by sleep command to ensure user_data gets completed first.
  # Delay of 5 & 10 didn't work but of 30 secs worked.
  provisioner "remote-exec" {
    inline = [
      "sleep 30",
      "sudo mv /tmp/id_rsa /home/ansible/.ssh/",
      "sudo chown ansible:ansible /home/ansible/.ssh/id_rsa",
      "sudo chmod 600 /home/ansible/.ssh/id_rsa"
    ]
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("ssh-keys\\main-vpc-pubsub-01-1a-key")
    host        = aws_instance.pubjump.public_ip
  }
}

# Squid proxy server on ubuntu.

resource "aws_instance" "squid-proxy" {
  ami                         = data.aws_ami.ubuntu-ami-id.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.main-vpc-pubsub-01-1a-key.key_name
  subnet_id                   = aws_subnet.main-vpc-pubsub-01-1a.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow-pubjump-ssh.id, aws_security_group.allow-pubans-ssh.id, aws_security_group.allow-proxy-traffic.id]
  private_ip                  = var.squid-proxy-pvt-ip
  tenancy                     = "default"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name      = var.squid-proxy-hostname
    Env       = "Management"
    App       = "Proxy"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
  user_data = templatefile("template-files\\pubans-ansible-pre-requisites.sh.tftpl", { pubans_ansible_pub_key = var.pubans-ansible-pub-key })
}

# Ansible server on Redhat in public subnet.

resource "aws_instance" "pubans" {
  ami                         = data.aws_ami.redhat-ami-id.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.main-vpc-pubsub-01-1a-key.key_name
  subnet_id                   = aws_subnet.main-vpc-pubsub-01-1a.id
  associate_public_ip_address = true # To install ansible without proxy server using user_data.
  vpc_security_group_ids      = [aws_security_group.allow-pubjump-ssh.id]
  private_ip                  = var.pubans-pvt-ip
  tenancy                     = "default"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name      = var.pubans-hostname
    Env       = "Management"
    App       = "Ansible"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
  user_data = templatefile("template-files\\pubans-init.sh.tftpl", { pubans_ansible_pub_key = var.pubans-ansible-pub-key })
}

# Ubuntu jump server in private subnet.

resource "aws_instance" "pvtjump" {
  ami                         = data.aws_ami.ubuntu-ami-id.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.main-vpc-pvtsub-01-1a-key.key_name
  subnet_id                   = aws_subnet.main-vpc-pvtsub-01-1a.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.allow-pubjump-ssh.id, aws_security_group.allow-pubans-ssh.id]
  private_ip                  = var.pvtjump-pvt-ip
  tenancy                     = "default"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name      = var.pvtjump-hostname
    Env       = "Management"
    App       = "Jump Server"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
  user_data = templatefile("template-files\\pubans-ansible-pre-requisites.sh.tftpl", { pubans_ansible_pub_key = var.pubans-ansible-pub-key })
}

# Ansible server on redhat server in private subnet.

resource "aws_instance" "pvtans" {
  ami                         = data.aws_ami.redhat-ami-id.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.main-vpc-pvtsub-01-1a-key.key_name
  subnet_id                   = aws_subnet.main-vpc-pvtsub-01-1a.id
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.allow-pvtjump-ssh.id, aws_security_group.allow-pubans-ssh.id]
  private_ip                  = var.pvtans-pvt-ip
  tenancy                     = "default"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name      = var.pvtans-hostname
    Env       = "Management"
    App       = "Jump Server"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
  user_data = templatefile("template-files\\pubans-init.sh.tftpl", { pubans_ansible_pub_key = var.pubans-ansible-pub-key })
}
