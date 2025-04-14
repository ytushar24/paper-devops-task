provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP access"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "web_server" {
  ami                    = "ami-0e1b8bd9daef6633a" # Amazon Linux 2 AMI
  instance_type          = var.instance_type
  key_name               = var.key_name
  security_groups        = [aws_security_group.allow_ssh_http.name]

  #user_data = <<-EOF
   #           #!/bin/bash
    #          yum update -y
     #         amazon-linux-extras install docker -y
      #        service docker start
       #       usermod -a -G docker ec2-user
        #      docker run -d -p 80:80 nginx
         #     EOF

  tags = {
    Name = "PaperSocial-AWS-Instance"
  }
}

