provider "aws" {
  region = var.aws_region
}
resource "tls_private_key" "my_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my_key" {
  key_name   = "my-key"
  public_key = tls_private_key.my_key.public_key_openssh
}

output "private_key_pem" {
  value     = tls_private_key.my_key.private_key_pem
  sensitive = true
}

module "jenkins" {
  source             = "./modules/ec2"
  instance_name      = "jenkins-master"
  instance_type      = var.instance_type
  ami_id             = var.ami_id
  key_name           = aws_key_pair.my_key.key_name
  security_group_ids = [aws_security_group.ci_cd_sg.id]
}

module "nexus" {
  source             = "./modules/ec2"
  instance_name      = "nexus"
  instance_type      = var.instance_type
  ami_id             = var.ami_id
  key_name           = aws_key_pair.my_key.key_name
  security_group_ids = [aws_security_group.ci_cd_sg.id]
}

# Security Group
resource "aws_security_group" "ci_cd_sg" {
  name_prefix = "ci_cd_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

