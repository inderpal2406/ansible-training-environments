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
}
/*
# Squid proxy server on ubuntu.

resource "aws_instance" "squid-proxy" {
  ami                         = data.aws_ami.ubuntu-ami-id
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
}

# Ansible server on Redhat in public subnet.

resource "aws_instance" "pubans" {
  ami                         = data.aws_ami.redhat-ami-id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.main-vpc-pubsub-01-1a-key.key_name
  subnet_id                   = aws_subnet.main-vpc-pubsub-01-1a.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow-pubjump-ssh.id]
  private_ip                  = var.pubans-pvt-ip
  tenancy                     = "default"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags {
    Name      = var.pubans-hostname
    Env       = "Management"
    App       = "Ansible"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}
*/