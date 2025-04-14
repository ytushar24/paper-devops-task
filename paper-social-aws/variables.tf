variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "vm-kp"
}

variable "public_key_path" {
  description = "~/.ssh/terraform-key.pub"
}

