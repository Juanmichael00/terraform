provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "efs" {
  source = "terraform-aws-modules/efs/aws"

  # File system
  name           = var.efs_name
  creation_token = "example-token"
  encrypted      = true
  #  kms_key_arn    = "arn:aws:kms:eu-west-1:111122223333:key/1234abcd-12ab-34cd-56ef-1234567890ab"

  performance_mode = "generalPurpose"
  throughput_mode  = "elastic"
  #  provisioned_throughput_in_mibps = 256

  # Mount targets
  mount_targets = {
    "sa-east-1a" = {
      subnet_id = "subnet-id"
    }
    "sa-east-1b" = {
      subnet_id = "subnet-id"
    }
  }

  # Security group for EFS
  security_group_description = "SG-efs-tf"
  security_group_vpc_id      = var.vpc_id
  security_group_rules = {
    vpc = {
      # relying on the defaults provided for EFS/NFS (2049/TCP + ingress)
      description = "NFS ingress from VPC public subnets"
      cidr_blocks = ["172.19.20.0/22", "172.19.24.0/22"]
    }
  }

  # Access point(s)
  access_points = {
    efs-mount = {
      root_directory = {
        path = "/efs"
        creation_info = {
          owner_gid   = 1000
          owner_uid   = 1000
          permissions = "755"
        }
      }
    }
    efs-home-mount = {
      root_directory = {
        path = "/efs/home"
        creation_info = {
          owner_gid   = 1000
          owner_uid   = 1000
          permissions = "755"
        }
      }
    }
    efs-home-teste-mount = {
      root_directory = {
        path = "/efs/home/teste"
        creation_info = {
          owner_gid   = 1000
          owner_uid   = 1000
          permissions = "755"
        }
      }
    }
  }

  # Backup policy
  enable_backup_policy = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Author      = "Your name is..."
  }
}
