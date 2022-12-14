provider "aws" {
  region  = "region"
  profile = "user cli"
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "my-instance-terraform"

  ami                    = "ami-0ada6d94f396377f2"
  instance_type          = "t3.small"
  key_name               = "key-pair"
  monitoring             = true
  vpc_security_group_ids = [""]
  subnet_id              = ""

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Autor       = "Name"
  }
}