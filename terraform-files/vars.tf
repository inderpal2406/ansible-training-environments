# Define variables.

variable "public-subnet-cidr" {
  type        = string
  description = "CIDR range of Public Subnet."
}

variable "private-subnet-cidr" {
  type        = string
  description = "CIDR range of Private Subnet."
}