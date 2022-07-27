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
