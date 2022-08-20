variable "aws_profile" {
  type        = string
  description = "AWS programmatic credentials to be used from AWS profile."
  sensitive   = true
}

variable "main-vpc-cidr" {
  type        = string
  description = "CIDR range of main-vpc."
}

variable "main-vpc-pubsub-01-1a-cidr" {
  type        = string
  description = "CIDR range of public subnet 1 in ap-south-1a AZ in main-vpc."
}

variable "main-vpc-pvtsub-01-1a-cidr" {
  type        = string
  description = "CIDR range of private subnet 1 in ap-south-1a AZ in main-vpc."
}

variable "main-vpc-pvtsub-02-1b-cidr" {
  type        = string
  description = "CIDR range of private subnet 2 in ap-south-1b AZ in main-vpc."
}

variable "main-vpc-pvtsub-03-1c-cidr" {
  type        = string
  description = "CIDR range of private subnet 3 in ap-south-1c AZ in main-vpc."
}

variable "main-vpc-pvtsub-04-1c-cidr" {
  type        = string
  description = "CIDR range of private subnet 4 in ap-south-1c AZ in main-vpc."
}
