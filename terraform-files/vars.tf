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