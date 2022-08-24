provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "teste-Terraform" {  
   cidr_block = "10.0.0.0/16"
   enable_dns_hostnames = true
  
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.teste-Terraform.id
  cidr_block = "10.0.1.0/24"
  
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.teste-Terraform.id
  cidr_block = "10.0.2.0/24"
}