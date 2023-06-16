provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}

resource "aws_instance" "my_ubuntu" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.DynamicSecurityGroup_1.id]
  subnet_id              = aws_subnet.prod_subnet.id
  user_data              = file("user_data.sh")
  tags = {
    Name = "Server with security group"
  }
}

resource "aws_vpc" "prod_vpc" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = "prod"
  }
}

resource "aws_subnet" "prod_subnet" {
  vpc_id                  = aws_vpc.prod_vpc.id
  cidr_block              = "10.10.0.0/24"
  availability_zone       = data.aws_availability_zones.working.names[0]
  map_public_ip_on_launch = "true"
  tags = {
    Name    = "Subnet in ${data.aws_availability_zones.working.names[0]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
  }
}

resource "aws_security_group" "DynamicSecurityGroup_1" {
  name        = "WebServer security group"
  description = "Security group http https ssh"
  vpc_id      = aws_vpc.prod_vpc.id

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DynamicSecurityGroup_1"
  }
}

resource "aws_internet_gateway" "prod_internet_gateway" {
  vpc_id = aws_vpc.prod_vpc.id
  tags = {
    Name = "prod_gateway"
  }
}

resource "aws_route_table" "routing_table_prod" {
  vpc_id = aws_vpc.prod_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod_internet_gateway.id
  }
  tags = {
    Name = "prod_route_table"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.prod_subnet.id
  route_table_id = aws_route_table.routing_table_prod.id
}

output "prod_vpc_id" {
  value = aws_vpc.prod_vpc.id
}

output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names
}

output "subnet_id" {
  value = aws_subnet.prod_subnet.id
}

output "subnet_name" {
  value = aws_subnet.prod_subnet.tags
}

