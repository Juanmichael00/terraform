provider "aws" {
  region = "region"
  profile = ""  
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "VPC_PROD"
  cidr = "172.19.0.0/16"

  azs             = ["region", "region", "region"]
  private_subnets = ["172.19.0.0/22", "172.19.4.0/22", "172.19.8.0/22"]
  public_subnets  = ["172.19.20.0/22", "172.19.24.0/22", "172.19.28.0/22"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "Prod"
    Autor = "Name"
  }
}
