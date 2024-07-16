provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Security group to allow SSH access"
  vpc_id = aws_vpc.first-vpc.id
 
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

resource "aws_instance" "web-server" {
  ami           = "ami-04a81a99f5ec58529"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  subnet_id = aws_subnet.first-vpc-public_subent_01.id
  for_each = toset(["Jenkins-Master","Jenkins-Slave", "Ansible"])
   tags = {
     Name = "${each.key}"
   }

}

  resource "aws_vpc" "first-vpc" {
       cidr_block = "10.1.0.0/16"
       tags = {
        Name = "first-vpc"
     }
   }


   resource "aws_subnet" "first-vpc-public_subent_01" {
    vpc_id = aws_vpc.first-vpc.id
    cidr_block = "10.1.3.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
      Name = "first-vpc-public_subent_01"
    }
}


resource "aws_subnet" "first-vpc-public_subent_02" {
    vpc_id = aws_vpc.first-vpc.id
    cidr_block = "10.1.4.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1b"
    tags = {
      Name = "first-vpc-public_subent_02"
    }
}
resource "aws_internet_gateway" "first-igw" {
    vpc_id = aws_vpc.first-vpc.id
    tags = {
      Name = "first-igw"
    }
}

resource "aws_route_table" "first-public-rt" {
    vpc_id = aws_vpc.first-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.first-igw.id
    }
    tags = {
      Name = "first-public-rt"
    }
}

resource "aws_route_table_association" "first-rta-public-subent-01" {
    subnet_id = aws_subnet.first-vpc-public_subent_01.id
    route_table_id = aws_route_table.first-public-rt.id
}

resource "aws_route_table_association" "first-rta-public-subent-02" {
    subnet_id = aws_subnet.first-vpc-public_subent_02.id
    route_table_id = aws_route_table.first-public-rt.id
}

