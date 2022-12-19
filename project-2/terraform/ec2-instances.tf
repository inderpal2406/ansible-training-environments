# Public jump server (bastion host) on ubuntu.

resource "aws_instance" "pubjump" {
  ami                         = data.aws_ami.ubuntu-ami-id.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.main-vpc-pubsub-01-1a-key.key_name
  subnet_id                   = aws_subnet.main-vpc-pubsub-01-1a.id
  associate_public_ip_address = true # Needed so that we can reach out to it from public internet.
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
  # As we migrated from CG Laptop to AWS workspace to perform terraform functions.
  # Because laptop had restrictions due to recent updates, & we wanted to do everything from one place.
  # Workspace being behind proxy, provisioner didn't work as connection on SSH port didn't work through proxy.
  # Though pubjump got created with errors, with every terraform apply, terraform wanted to replace it,
  # as it was marked as tainted in terraform state.
  # We though, including lifecycle block to ignore changes would help, but it didn't. Still terraform asked to replace in plan.
  # Lifecycle would have worked if resource would have got created without errors & wasn't marked as tainted.
  # Then lifecycle would have ignored further changes to attributes. So, we commented lifecycle block, as it is not needed.
  /*
  lifecycle {
    ignore_changes = all  # Will ignore changes for all attributes.
    # Alternately, if we want to ignore changes for only specific attributes, then we can specify list of those.
#    ignore_changes = [
#      tags
#    ]
  }
  */
  # To overcome problem of recreating/replacing pubjump everytime we run terraform plan, we 
  # used terraform untaint command to untaint pubjump in terraform state file.
  # Now terraform didn't prompt to replace it (during plan) as it is not tainted in terraform state.
}

# Ansible server on Redhat in public subnet.

resource "aws_instance" "pubans" {
  ami                         = data.aws_ami.redhat-ami-id.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.main-vpc-pubsub-01-1a-key.key_name
  subnet_id                   = aws_subnet.main-vpc-pubsub-01-1a.id
  associate_public_ip_address = true # To install ansible without proxy server using user_data.
  # We tried to not assign public IP address to ansible server by keeping the above option as false.
  # In that case, ansible didn't get installed. So, we need public IP address to get packages installed or a proxy server.
  # Also we tried manually to install ansible on pubans with no public IP assigned to it.
  # Yum failed with timeout error while contacting RedHat package repositories.
  vpc_security_group_ids = [aws_security_group.allow-pubjump-ssh.id]
  private_ip             = var.pubans-pvt-ip
  tenancy                = "default"
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
  # Private key of ansible user needs to be manually copied from pubjump to pubans.
  # Though it has a public IP but ssh is not open for public internet traffic.
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
  # Pub key of ansible user whose pvt key is there on pubans, is being copied to authorized_keys file of ansible user on
  # pvtans host to enable password less ssh from pubans to manage pvtans from pubans server.
  # Separate pvt key of ansible user would be copied to pvtans via pvtjump.
  # Pub key of this separate pvt key would be copied to all hosts in pvt subnets in pvtans-ansible-prerequisites.sh.tftpl
  # file, so that all pvt subnet hosts can be managed by pvtans server.
}

# Ubuntu web server in dev environment.

resource "aws_instance" "web-dev" {
  ami                         = data.aws_ami.ubuntu-ami-id.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.main-vpc-pvtsub-02-1b-key.key_name
  subnet_id                   = aws_subnet.main-vpc-pvtsub-02-1b.id
  associate_public_ip_address = false
  # We decided to manage remaining pvt subnet hosts using pvtans ansible server.
  # In enhanced playbooks, then will need to maintain separate inventory for pvtans and modify ansible.cfg everytime separately for both ans servers.
  # Hence, decided to manage all hosts using one ansible server which is pubans.
  # Hence, below security groups are commented and new ones are added in line below to allow incoming traffic from pubans.
  #vpc_security_group_ids      = [aws_security_group.allow-pvtjump-ssh.id, aws_security_group.allow-pvtans-ssh.id, aws_security_group.dev-sg.id]
  vpc_security_group_ids = [aws_security_group.allow-pvtjump-ssh.id, aws_security_group.allow-pubans-ssh.id, aws_security_group.dev-sg.id]
  private_ip             = var.web-dev-pvt-ip
  tenancy                = "default"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name      = var.web-dev-hostname
    Env       = "Dev"
    App       = "Web Server"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
  # Comment below user_data and add new user_data to enable server management using pubans server.
  #user_data = templatefile("template-files\\pvtans-ansible-pre-requisites.sh.tftpl", { pvtans_ansible_pub_key = var.pvtans-ansible-pub-key })
  user_data = templatefile("template-files\\pubans-ansible-pre-requisites.sh.tftpl", { pubans_ansible_pub_key = var.pubans-ansible-pub-key })
  # Same above changes for management through pubans are made in hosts below.
}

# Redhat database server in dev environment.

resource "aws_instance" "db-dev" {
  ami                         = data.aws_ami.redhat-ami-id.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.main-vpc-pvtsub-02-1b-key.key_name
  subnet_id                   = aws_subnet.main-vpc-pvtsub-02-1b.id
  associate_public_ip_address = false
  #vpc_security_group_ids      = [aws_security_group.allow-pvtjump-ssh.id, aws_security_group.allow-pvtans-ssh.id, aws_security_group.dev-sg.id]
  vpc_security_group_ids = [aws_security_group.allow-pvtjump-ssh.id, aws_security_group.allow-pubans-ssh.id, aws_security_group.dev-sg.id]
  private_ip             = var.db-dev-pvt-ip
  tenancy                = "default"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name      = var.db-dev-hostname
    Env       = "Dev"
    App       = "DB Server"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
  #user_data = templatefile("template-files\\pvtans-ansible-pre-requisites.sh.tftpl", { pvtans_ansible_pub_key = var.pvtans-ansible-pub-key })
  user_data = templatefile("template-files\\pubans-ansible-pre-requisites.sh.tftpl", { pubans_ansible_pub_key = var.pubans-ansible-pub-key })
}

/*
# Test redhat instance to install ansible latest version.

resource "aws_instance" "testans" {
  ami                         = data.aws_ami.redhat-ami-id.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.main-vpc-pubsub-01-1a-key.key_name
  subnet_id                   = aws_subnet.main-vpc-pubsub-01-1a.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow-public-ssh.id]
  private_ip                  = "10.0.0.7"
  tenancy                     = "default"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name      = "testans"
    Env       = "Management"
    App       = "Ansible"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
  user_data = templatefile("template-files\\pubans-ansible-pre-requisites.sh.tftpl", { pubans_ansible_pub_key = var.pubans-ansible-pub-key })
}
*/

# Ubuntu web server in test environment.

resource "aws_instance" "web-test" {
  ami                         = data.aws_ami.ubuntu-ami-id.id
  instance_type               = "t3.nano" # Availability zone 1c in ap-south-1 reions doesn't support t2 instance family.
  key_name                    = aws_key_pair.main-vpc-pvtsub-03-1c-key.key_name
  subnet_id                   = aws_subnet.main-vpc-pvtsub-03-1c.id
  associate_public_ip_address = false
  #vpc_security_group_ids      = [aws_security_group.allow-pvtjump-ssh.id, aws_security_group.allow-pvtans-ssh.id, aws_security_group.dev-sg.id]
  vpc_security_group_ids = [aws_security_group.allow-pvtjump-ssh.id, aws_security_group.allow-pubans-ssh.id, aws_security_group.test-sg.id]
  private_ip             = var.web-test-pvt-ip
  tenancy                = "default"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name      = var.web-test-hostname
    Env       = "Test"
    App       = "Web Server"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
  #user_data = templatefile("template-files\\pvtans-ansible-pre-requisites.sh.tftpl", { pvtans_ansible_pub_key = var.pvtans-ansible-pub-key })
  user_data = templatefile("template-files\\pubans-ansible-pre-requisites.sh.tftpl", { pubans_ansible_pub_key = var.pubans-ansible-pub-key })
}

# Redhat database server in test environment.

resource "aws_instance" "db-test" {
  ami           = data.aws_ami.redhat-ami-id.id
  instance_type = "t3.small" # RedHat flavor doesn't support t3.nano. Maybe due to root storage disk of small capacity coming by default.
  # With t3.micro offers 1 GB RAM which was falling short during ansible-playbook execution to install packages on db-test.
  key_name                    = aws_key_pair.main-vpc-pvtsub-03-1c-key.key_name
  subnet_id                   = aws_subnet.main-vpc-pvtsub-03-1c.id
  associate_public_ip_address = false
  #vpc_security_group_ids      = [aws_security_group.allow-pvtjump-ssh.id, aws_security_group.allow-pvtans-ssh.id, aws_security_group.dev-sg.id]
  vpc_security_group_ids = [aws_security_group.allow-pvtjump-ssh.id, aws_security_group.allow-pubans-ssh.id, aws_security_group.test-sg.id]
  private_ip             = var.db-test-pvt-ip
  tenancy                = "default"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name      = var.db-test-hostname
    Env       = "Test"
    App       = "DB Server"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
  #user_data = templatefile("template-files\\pvtans-ansible-pre-requisites.sh.tftpl", { pvtans_ansible_pub_key = var.pvtans-ansible-pub-key })
  user_data = templatefile("template-files\\pubans-ansible-pre-requisites.sh.tftpl", { pubans_ansible_pub_key = var.pubans-ansible-pub-key })
}

# Ubuntu web server in stg environment.

resource "aws_instance" "web-stg" {
  ami                         = data.aws_ami.ubuntu-ami-id.id
  instance_type               = "t3.nano" # Availability zone 1c in ap-south-1 reions doesn't support t2 instance family.
  key_name                    = aws_key_pair.main-vpc-pvtsub-04-1c-key.key_name
  subnet_id                   = aws_subnet.main-vpc-pvtsub-04-1c.id
  associate_public_ip_address = false
  #vpc_security_group_ids      = [aws_security_group.allow-pvtjump-ssh.id, aws_security_group.allow-pvtans-ssh.id, aws_security_group.dev-sg.id]
  vpc_security_group_ids = [aws_security_group.allow-pvtjump-ssh.id, aws_security_group.allow-pubans-ssh.id, aws_security_group.stg-sg.id]
  private_ip             = var.web-stg-pvt-ip
  tenancy                = "default"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name      = var.web-stg-hostname
    Env       = "Stg"
    App       = "Web Server"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
  #user_data = templatefile("template-files\\pvtans-ansible-pre-requisites.sh.tftpl", { pvtans_ansible_pub_key = var.pvtans-ansible-pub-key })
  user_data = templatefile("template-files\\pubans-ansible-pre-requisites.sh.tftpl", { pubans_ansible_pub_key = var.pubans-ansible-pub-key })
}

# Redhat database server in stg environment.

resource "aws_instance" "db-stg" {
  ami                         = data.aws_ami.redhat-ami-id.id
  instance_type               = "t3.small"
  key_name                    = aws_key_pair.main-vpc-pvtsub-04-1c-key.key_name
  subnet_id                   = aws_subnet.main-vpc-pvtsub-04-1c.id
  associate_public_ip_address = false
  #vpc_security_group_ids      = [aws_security_group.allow-pvtjump-ssh.id, aws_security_group.allow-pvtans-ssh.id, aws_security_group.dev-sg.id]
  vpc_security_group_ids = [aws_security_group.allow-pvtjump-ssh.id, aws_security_group.allow-pubans-ssh.id, aws_security_group.stg-sg.id]
  private_ip             = var.db-stg-pvt-ip
  tenancy                = "default"
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name      = var.db-stg-hostname
    Env       = "Test"
    App       = "DB Server"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
  #user_data = templatefile("template-files\\pvtans-ansible-pre-requisites.sh.tftpl", { pvtans_ansible_pub_key = var.pvtans-ansible-pub-key })
  user_data = templatefile("template-files\\pubans-ansible-pre-requisites.sh.tftpl", { pubans_ansible_pub_key = var.pubans-ansible-pub-key })
}
