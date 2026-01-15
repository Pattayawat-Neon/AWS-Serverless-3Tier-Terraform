terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket = "daily-finance-tfstate-dev"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
