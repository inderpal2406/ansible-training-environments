# Define EC2 instances.

# Before creating EC2 instance, have the security group and key-pair ready beforehand.

# Bastion server.
/*
resource "aws_instance" "bastion-server" {
    ami = "ami-068257025f72f470d"
    instance_type = "t2.micro"
    key_name = aws_key_pair.bastion-server-key.key_name
    subnet_id = aws_subnet.main-vpc-pub-subnet.id
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.allow-public-ssh.id]
    private_ip = ""
    tenancy = "shared"
    metadata_options {
      http_endpoint = "enabled"
      https_tokens = "required" # Enables IMDSv2 service only.
    }
    tags = {
        Name = "bastion-server"
        Terraform = "True"
        Owner = "Vikram Singh"
    }
}
*/
