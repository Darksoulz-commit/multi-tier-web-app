provider "aws" {
  region = "ap-south-1" # Mumbai Region
}

# 1. Security Group Configuration
resource "aws_security_group" "devops_sg" {
  name        = "devops-project-sg"
  description = "Allow SSH, Jenkins, and Python API ports"

  # SSH Access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Jenkins Port
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Python Backend API Port
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. EC2 Instance Configuration
resource "aws_instance" "devops_server" {
  ami           = "ami-02eb7a4783e7e9317" # Ubuntu 22.04 LTS Free Tier AMI
  instance_type = "t3.micro"
  key_name      = "naveen-server-key"
  
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  tags = {
    Name = "DevOps-CI-CD-Server"
  }
}

output "server_public_ip" {
  value = aws_instance.devops_server.public_ip
}