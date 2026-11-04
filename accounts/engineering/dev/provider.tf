terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"

  # assume_role {
    # role_arn = "arn:aws:iam::999999999999:role/Engineering-Dev-Deployment-Role"
    # session_name = "TerraformDevDeploymentSession"
# }
}