variable "aws_profile" {
  type        = string
  description = "AWS programmatic credentials to be used from AWS profile."
  sensitive   = true
}

variable "main-vpc-cidr" {
  type        = string
  description = "CIDR range of main-vpc."
}
