provider "aws" {
  region = "eu-west-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.22"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }

    http = {
      source  = "hashicorp/http"
      version = "3.4.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
  }
}
