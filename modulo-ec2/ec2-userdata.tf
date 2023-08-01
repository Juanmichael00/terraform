provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "my-app-instance"

  ami                    = "ami-0f34c5ae932e6f0e4"
  instance_type          = "t3a.small"
  key_name               = "my-app"
  monitoring             = true
  vpc_security_group_ids = ["sg-09ab5d08778d57308"]
  subnet_id              = "subnet-0269b9c170f71052c"
  user_data = <<EOF
#!bin/bash
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
echo "<html><body><h2>Aplicação de teste com WAF </h2><br> <h3>Endreço: $(hostname -f)</h3></body></html>" > /var/www/html/index.html

EOF

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Autor       = "Name"
  }
}
