data "aws_ami" "ubuntu" {
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

# The template provider is used here to create a data source to be used in user_data in ec2-instances.tf file.
# Below format of user_data requires template provider which has been archived by Hashicorp.
# Hashicorp now suggests to use templatefile() or cloudinit provider instead.
#user_data = data.template_file.bastion-server-init.rendered
/*
data "template_file" "bastion-server-init" {
  template = file(".\\template-files\\bastion-server-init.sh.tpl")
  vars = {
    bastion_server_pvt_ip   = var.bastion-server-pvt-ip
    bastion_server_hostname = var.bastion-server-hostname
    ansible_server_pvt_ip   = var.ansible-server-pvt-ip
    ansible_server_hostname = var.ansible-server-hostname
  }
}
*/

# RedHat Linux AMI - ami-05c8ca4485f8b138a for target hosts.

data "aws_ami" "redhat" {
  most_recent = true
  owners      = ["309956199498"] # RedHat
  filter {
    name   = "name"
    values = ["RHEL-8.6.0_HVM-20220503-x86_64-2-Hourly2-GP2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# CentOS Linux AMI for ansible-server but couldn't be used as it needs to be subscribed.

data "aws_ami" "centos" {
  most_recent = true
  owners      = ["679593333241"]
  filter {
    name   = "name"
    values = ["CentOS-8-ec2-8.2.2004-20200923-1.x86_64-471d022d-974f-4f9c-8e39-b00d9b583833-ami-03b6a1d995f5a5146.4"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
