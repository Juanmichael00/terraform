# variables.tf

variable "aws_region" {
  description = "AWS region for the EFS filesystem"
  type        = string
  default     = "us-east-1" # alterar
}

variable "aws_profile" {
  description = "AWS profile to use"
  type        = string
  default     = "your user CLI"  # alterar
}

variable "efs_name" {
  description = "Name of the EFS filesystem"
  type        = string
  default     = "efs-tf" # alterar
}

variable "vpc_id" {
  description = "vpc details"
  type        = string
  default     = "vpc-id" # alterar
}
