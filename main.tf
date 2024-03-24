terraform { 
    required_providers {
        aws = {
            source = 'hashicorp/aws'
            version = '~> 4.0'
        }
    }
}
provider "aws" {
  region = "us-east-1"  # Adjust the region as per your requirement
}

# Step 1: Deploy EC2 Instance
resource "aws_instance" "jenkins_instance" {
  ami           = "ami-0c55b159cbfafe1f0"  # Choose an appropriate AMI
  instance_type = "t2.micro"  # Adjust instance type as per your requirement
  subnet_id     = "subnet-xxxxxxxxxxxxxxx"  # Specify your subnet ID

  tags = {
    Name = "Jenkins Instance"
  }

  # Step 2: Bootstrap Instance with Jenkins Installation
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install java-1.8.0-openjdk-devel -y
              sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
              sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
              sudo yum install jenkins -y
              sudo systemctl start jenkins
              sudo systemctl enable jenkins
              EOF
}

# Step 3: Create Security Group for Jenkins
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow port 22 and 8080"

  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow 8080 traffic"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
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

# Step 4: Create S3 Bucket for Jenkins Artifacts
resource "aws_s3_bucket" "jenkins_artifacts_bucket" {
  bucket = "jenkins-artifacts-bucket"
  acl    = "private"
}

# Output EC2 Public IP
output "jenkins_public_ip" {
  value = aws_instance.jenkins_instance.public_ip
}