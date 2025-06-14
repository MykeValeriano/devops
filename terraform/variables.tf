variable "ami_id" {
  description = "AMI ID"
  type = string
}

variable "instance_type" {
  description = "Instance Type"
  type = string
}

variable "instance_name" {
  description = "Instance Tag Name"
  type = string
}

variable "region" {
  description = "AWS Region"
  type = string
}
