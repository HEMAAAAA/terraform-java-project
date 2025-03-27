terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.75.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0453ec754f44f9a4a"
  instance_type = "t2.micro"
  tags = {
    Name = "Myec2"
  }
}
