provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "teste-Terraform" {  
   cidr_block = "10.0.0.0/16"
   enable_dns_hostnames = true
  
}