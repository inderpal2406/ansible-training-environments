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

variable "pubjump-pvt-ip" {
  type        = string
  description = "Private IP address of pubjump host."
}

variable "pubjump-hostname" {
  type        = string
  description = "Hostname of pubjump host."
}

variable "squid-proxy-pvt-ip" {
  type        = string
  description = "Private IP address of squid proxy host."
}

variable "squid-proxy-hostname" {
  type        = string
  description = "Hostname of squid proxy host."
}

variable "pubans-pvt-ip" {
  type        = string
  description = "Private IP address of pubans host."
}

variable "pubans-hostname" {
  type        = string
  description = "Hostname of pubans host."
}

variable "pvtjump-pvt-ip" {
  type        = string
  description = "Private IP address of pvtjump host."
}

variable "pvtjump-hostname" {
  type        = string
  description = "Hostname of pvtjump host."
}

variable "pvtans-pvt-ip" {
  type        = string
  description = "Private IP address of pvtans host."
}

variable "pvtans-hostname" {
  type        = string
  description = "Hostname of pvtans host."
}

variable "pubans-ansible-pub-key" {
  type        = string
  description = "Public key of ansible on pubans host."
}

variable "pvtans-ansible-pub-key" {
  type        = string
  description = "Public key of ansible on pvtans host."
}

variable "web-dev-pvt-ip" {
  type        = string
  description = "Private IP address of web-dev host."
}

variable "web-dev-hostname" {
  type        = string
  description = "Hostname of web-dev host."
}

variable "db-dev-pvt-ip" {
  type        = string
  description = "Private IP address of db-dev host."
}

variable "db-dev-hostname" {
  type        = string
  description = "Hostname of db-dev host."
}

variable "web-test-pvt-ip" {
  type        = string
  description = "Private IP address of web-test host."
}

variable "web-test-hostname" {
  type        = string
  description = "Hostname of web-test host."
}

variable "db-test-pvt-ip" {
  type        = string
  description = "Private IP address of db-test host."
}

variable "db-test-hostname" {
  type        = string
  description = "Hostname of db-test host."
}

variable "web-stg-pvt-ip" {
  type        = string
  description = "Private IP address of web-stg host."
}

variable "web-stg-hostname" {
  type        = string
  description = "Hostname of web-stg host."
}

variable "db-stg-pvt-ip" {
  type        = string
  description = "Private IP address of db-stg host."
}

variable "db-stg-hostname" {
  type        = string
  description = "Hostname of db-stg host."
}

variable "win-pubjump-pvt-ip" {
  type        = string
  description = "Private IP address of win-pubjump host."
}

variable "win-pubjump-hostname" {
  type        = string
  description = "Hostname of win-pubjump host."
}
