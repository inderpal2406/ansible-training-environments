# Define EC2 instances.

# Bastion server.
/*
resource "aws_instance" "bastion-server" {
    ami = "ami-068257025f72f470d"
    instance_type = "t2.micro"
    tags = {
        Name = "bastion-server"
        Terraform = "True"
        Owner = "Vikram Singh"
    }
}
*/
