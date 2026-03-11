# Provider configuration for this module.
# Recommended to run from the AWS Organizations management account
# or a delegated admin account with permissions to manage AWS Backup
# and AWS Organizations policies.

provider "aws" {
  # ATENÇÃO: região apenas de exemplo.
  # Defina aqui a região a partir da qual irá correr o Terraform
  # (idealmente alinhada com "backup_region" em backup_locals.tf).
  region = "eu-south-2"
}
