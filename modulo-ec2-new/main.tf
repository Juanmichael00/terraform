provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

################################################################################
# Criar um novo Security Group para a instância
################################################################################

resource "aws_security_group" "additional_security_group" {
  name        = "SG-teste123"
  description = "SG-teste123"
  vpc_id      = "vpc-id"

  // Regra para permitir tráfego SSH (porta 22) apenas do seu IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["your IP /32"]
  }
}


################################################################################
# EC2 Module
################################################################################

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "instance-tf"

  ami                         = "ami-093dda7753bcfc92a" # AMI Rocky Linux 8
  instance_type               = "t3a.medium"
  key_name                    = "your key pair"
  monitoring                  = true
  vpc_security_group_ids      = [aws_security_group.additional_security_group.id] #  sec group maquina
  subnet_id                   = "subnet-id"
  associate_public_ip_address = true

  ebs_block_device = [
    {
      device_name = "/dev/sda1"
      volume_size = 50
      volume_type = "gp3"
      iops        = 3000
      throughput  = 125
    },
  ]

  user_data = <<EOF
#!/bin/bash
hostnamectl set-hostname nome-server
dnf update -y

EOF

  tags = {
    Terraform    = "true"
    diretoria-cc = "teste"
    finalidade   = "teste"
    projeto      = "teste"
    Name         = "instance-tf"
  }
}

################################################################################
# Elastic IP
################################################################################

resource "aws_eip" "eip_instance-tf" {
  instance = module.ec2_instance.id
  tags = {
    Terraform    = "true"
    diretoria-cc = "teste"
    finalidade   = "teste"
    projeto      = "teste"
    Name         = "instance-tf"
  }
}