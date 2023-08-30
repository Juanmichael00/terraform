# variables.tf

variable "aws_region" {
  description = "AWS region for the EFS filesystem"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile to use"
  type        = string
  default     = "your user CLI"
}