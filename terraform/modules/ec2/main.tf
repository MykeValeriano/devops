resource "aws_instance" "ec2Instance" {
  ami = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}