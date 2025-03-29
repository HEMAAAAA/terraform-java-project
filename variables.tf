variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-084568db4383264d4" # Replace with the correct AMI ID
}

variable "key_name" {
  default = "my-terraform-key"
}

variable "public_key_path" {
  default = "~/.ssh/my-terraform-key.pub"
}

