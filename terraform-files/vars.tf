# Define variables.

variable "aws_profile" {
  type        = string
  description = "AWS profile name."
  sensitive   = true
}

variable "public-subnet-cidr" {
  type        = string
  description = "CIDR range of Public Subnet."
}

variable "private-subnet-cidr" {
  type        = string
  description = "CIDR range of Private Subnet."
}

variable "bastion-server-pvt-ip" {
  type        = string
  description = "Private IP address of Bastion server."
}

variable "bastion-server-hostname" {
  type        = string
  description = "Hostname of Bastion server."
}

variable "ansible-server-pvt-ip" {
  type        = string
  description = "Private IP address of Ansible server."
}

variable "ansible-server-hostname" {
  type        = string
  description = "Hostname of Ansible server."
}
