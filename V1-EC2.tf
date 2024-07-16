provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Security group to allow SSH access"
 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_instance" "shelly-server" {
  ami           = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.allow_ssh.name]

  tags = {
    Name = "shelly-server"
  }
}
