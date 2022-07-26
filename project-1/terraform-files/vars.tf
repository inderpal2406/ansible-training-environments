# Define variables.

variable "aws_profile" {
  type        = string
  description = "AWS profile name."
  sensitive   = true
}

variable "main-vpc-cidr" {
  type        = string
  description = "CIDR range of main vpc."
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

variable "squid-proxy-pvt-ip" {
  type        = string
  description = "Private IP address of Squid Proxy server."
}

variable "squid-proxy-hostname" {
  type        = string
  description = "Hostname of Squid proxy server."
}

variable "ubuntu10-pvt-ip" {
  type        = string
  description = "Private IP address of ubuntu10 server."
}

variable "ubuntu10-hostname" {
  type        = string
  description = "Hostname of ubuntu10 server."
}

variable "ubuntu11-pvt-ip" {
  type        = string
  description = "Private IP address of ubuntu11 server."
}

variable "ubuntu11-hostname" {
  type        = string
  description = "Hostname of ubuntu11 server."
}

variable "redhat10-pvt-ip" {
  type        = string
  description = "Private IP address of redhat10 server."
}

variable "redhat10-hostname" {
  type        = string
  description = "Hostname of redhat10 server."
}

variable "redhat11-pvt-ip" {
  type        = string
  description = "Private IP address of redhat11 server."
}

variable "redhat11-hostname" {
  type        = string
  description = "Hostname of redhat11 server."
}
