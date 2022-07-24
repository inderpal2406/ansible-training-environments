# Define key-pairs for SSH logins.

# Key pair for Bastion server.

resource "aws_key_pair" "bastion-server-key" {
  key_name   = "bastion-server-key"
  public_key = file(".\\ssh-keys\\bastion-server-key.pub")
  tags = {
    Name      = "bastion-server-key"
    Terraform = "True"
    Owner     = "Vikram Singh"
  }
}