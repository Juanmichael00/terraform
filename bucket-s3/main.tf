provider "aws" {
  region  = "region"
  profile = "user cli"
}

resource "aws_s3_bucket" "my-test-bucket" {

  bucket = "nome-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
    Managedby   = "Terraform"
    Autor       = "name"
  }

}

output "my-test-bucket" {
  value = aws_s3_bucket.my-test-bucket.bucket
}

output "my-test-bucket_arn" {
  value = aws_s3_bucket.my-test-bucket.arn
}
