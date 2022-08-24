provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "teste-Terraform" {  
   cidr_block = "10.0.0.0/16"
   enable_dns_hostnames = true
  
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id = aws_vpc.teste-Terraform.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id = aws_vpc.teste-Terraform.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2b"
  
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id = aws_vpc.teste-Terraform.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id = aws_vpc.teste-Terraform.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-west-2b"

}

// EC2

resource "aws_instance" "webserver_test" {
  ami = "ami-087c62243d86b286b"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet_a.id
  
}


// RDS

resource "aws_db_instance" "banco" {
  allocated_storage = 10
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  db_name = "banco"
  username = "admin"
  password = "Ulaw3801"
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.db_subnet.id

}

//ãgrupar subnets

resource "aws_db_subnet_group" "db_subnet" {
 name = "dbsubnet"
 subnet_ids = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]
  
}