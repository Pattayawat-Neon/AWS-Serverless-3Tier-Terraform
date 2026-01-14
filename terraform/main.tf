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

resource "aws_budgets_budget" "serverless-projects" {
    name = "monthly-budget"
    budget_type = "COST"
    limit_amount = "00.00"
    limit_unit = "USD"
    time_unit = "MONTHLY"   
    time_period_start = "2026-01-01_00:00"
}