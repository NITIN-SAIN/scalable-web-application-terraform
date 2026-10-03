terraform {
  backend "s3" {
    bucket = "scalable-web-terraform-state-586988810446"
    key    = "scalable-web/terraform.tfstate"
    region = "ap-south-1"
  }
  
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
