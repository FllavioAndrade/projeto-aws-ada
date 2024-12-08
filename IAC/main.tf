terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.70.0"
    }
  }
  backend "s3" {
    bucket = "terraform-state-ada-1182"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Projeto = "Ada Contabilidade"
      dono    = "Flavio de Andrade"
    }
  }
}