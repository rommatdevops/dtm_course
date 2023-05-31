provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_ubuntu" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t3.micro"
}
