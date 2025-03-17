# Lab 19: Terraform Modules
---
## Objectives:

* Manually create a VPC in your AWS account.

* Use Terraform modules to manage the VPC and EC2 instances.
  * The Network module includes two public subnets, route tables, and an internet gateway.
  * The Server module creates an EC2 instance with Nginx installed, a security group, and a key pair.

* Use the Server module twice to create EC2 instances in each subnet.

## File Structure:
```sh
.
├── main.tf
├── variables.tf
├── outputs.tf
├── modules/
│   ├── network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── server/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
```

### main.tf - Root Module
```sh
provider "aws" {
  region = "us-east-1"
}

module "network" {
  source   = "./modules/network"
  vpc_name = "my-vpc"
}

module "server_1" {
  source   = "./modules/server"
  subnet_id = module.network.public_subnet_1_id
  key_name  = "my-key"
  ami       = "ami-00b7c7d4689460eef"
}

module "server_2" {
  source   = "./modules/server"
  subnet_id = module.network.public_subnet_2_id
  key_name  = "my-key"
  ami       = "ami-00b7c7d4689460eef"
}
```
### variables.tf - Root Module
```sh
variable "vpc_name" {}
variable "key_name" {}
variable "ami" {}
```
### outputs.tf -Root Module
```sh
output "server_1_public_ip" {
  value = module.server_1.instance_public_ip
}

output "server_2_public_ip" {
  value = module.server_2.instance_public_ip
}
```

### modules/network/main.tf - Network Module
```sh
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = var.vpc_name }
}

resource "aws_subnet" "subnet_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "subnet_1_association" {
  subnet_id = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "subnet_2_association" {
  subnet_id = aws_subnet.subnet_2.id
  route_table_id = aws_route_table.rt.id
}
```
### modules/network/variables.tf
```sh
variable "vpc_name" {}
```
### modules/network/outputs.tf 
```sh
output "public_subnet_1_id" {
  value = aws_subnet.subnet_1.id
}

output "public_subnet_2_id" {
  value = aws_subnet.subnet_2.id
}
```

### modules/network/main.tf - server Module
```sh
resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  key_name      = var.key_name

  tags = { Name = "Nginx-Server" }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              EOF
}
```
### modules/server/variables.tf 
```sh
variable "subnet_id" {}
variable "ami" {}
variable "key_name" {}
```


### modules/server/outputs.tf
```sh
output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
```
### Initialize Terraform
```sh
terraform init
```
### Plan Deployment
```sh
terraform apply -auto-approve
```
### Apply Configuration
```sh
terraform apply -auto-approve
```

![Image](https://github.com/user-attachments/assets/552ead7a-7dea-40cc-9de3-27ad0f22f543)

![Image](https://github.com/user-attachments/assets/17c3daed-397a-4b36-b602-74dcc4fe86aa)

### Test Server Connectivity
```sh
curl http://52.90.9.223
curl http://98.80.13.211
```

