provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # Update with a valid AMI
  instance_type = "t2.micro"
  key_name      = "my-key"                 # Update with your SSH key
  tags = {
    Name = "AppServer"
  }
}

