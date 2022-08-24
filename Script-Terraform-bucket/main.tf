provider "aws" {

region = "us-west-2"

}

resource "aws_s3_bucket" "my-test-bucket" {
  bucket = "my-tf-test-bucket-75331181"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
    Managedby = "Terraform"
  }
}

