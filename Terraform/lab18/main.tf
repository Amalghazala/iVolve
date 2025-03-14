```sh
provider "aws" {
  region = var.region
}

resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  tags = { Name = "main-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = { Name = "main-igw" }
}

resource "aws_subnet" "subnets" {
  for_each = { for idx, subnet in var.subnets : idx => subnet }
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.az
  map_public_ip_on_launch = each.value.public
  tags = { Name = "subnet-${each.key}" }
}

resource "aws_eip" "nat" { domain = "vpc" }

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.subnets[0].id
  tags = { Name = "nat-gateway" }
}

resource "aws_security_group" "web_sg" {
  name = "web-security-group"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami           = "ami-014d544cfef21b42d"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnets[0].id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data     = file("user_data_nginx.sh")
  tags = { Name = "Nginx-Server" }
}

resource "aws_instance" "app_server" {
  ami           = "ami-014d544cfef21b42d"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnets[1].id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data     = file("user_data_apache.sh")
  tags = { Name = "Apache-Server" }
}

output "web_server_public_ip" {
  value = aws_instance.web_server.public_ip
}

output "app_server_private_ip" {
  value = aws_instance.app_server.private_ip
}
```
