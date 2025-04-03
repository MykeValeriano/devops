module "vpc" {
  source          = "./vpc"
  name            = var.name
  region          = var.region
  cidr_block      = var.cidr_block
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}