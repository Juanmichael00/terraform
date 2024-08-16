# variables.tf

variable "aws_region" {
  description = "AWS region for the WAF WebACLs and other resources"
  type        = string
  default     = "sa-east-1"
}

variable "aws_profile" {
  description = "AWS profile to use"
  type        = string
  default     = "user-cli-name"
}