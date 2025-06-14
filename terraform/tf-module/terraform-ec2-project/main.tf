provider "aws" {
  region = var.region
}

module "ec2_instance" {
  source      = "./modules/ec2"
  instance_type = var.instance_type
  ami_id       = var.ami_id
  key_name     = var.key_name
  security_group_ids = var.security_group_ids
  subnet_id = var.subnet_id
}

output "instance_id" {
  value = module.ec2_instance.instance_id
}

output "public_ip" {
  value = module.ec2_instance.public_ip
}