variable "cidr_block" {
  description = "AWS VPC CIDR Block"
  type        = string
}

variable "name" {
  description = "Name"
  type        = string
}

variable "azs" {
  description = "Availability Zone"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public Subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private Subnets"
  type        = list(string)
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}