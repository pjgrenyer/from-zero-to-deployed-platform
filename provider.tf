terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.13.0"
    }
  }

  backend "remote" {
    workspaces {
      name = "from-zero-to-deployed-platform"
    }
  }
}

provider "aws" {
  region     = "eu-west-2"
  access_key = var.access_key
  secret_key = var.access_secret
}
