# Terraform Lab 18: Variables and Loops
---
##  Objective:

This lab demonstrates how to use Terraform to create an AWS infrastructure with variables and loops. The setup includes:

* A Virtual Private Cloud (VPC)

* Public and private subnets

* Internet and NAT gateways

* Security groups

* EC2 instances running Nginx and Apache
---
## Project Structure
```sh
terraform_lab18/
│── main.tf             
│── variables.tf        
│── terraform.tfvars    
│── outputs.tf          
│── user_data_nginx.sh  
│── user_data_apache.sh
```
---
## Steps to Deploy the Infrastructure

### 1. Initialize Terraform:
Run the following command to initialize Terraform and download required providers:
```sh
touch variables.tf
terraform init
```
### 2. Define AWS Provider

In main.tf, configure AWS as the provider:
```sh
provider "aws" {
  region = var.region
}
```
### 3. Create VPC

Define the VPC with the following code in main.tf:
```sh
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  tags = { Name = "main-vpc" }
}
```
### 4.  Create an Internet Gateway

Attach an internet gateway to the VPC:
```sh
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = { Name = "main-igw" }
}
```
### 5. Create Public and Private Subnets

Use loops to create subnets dynamically:
```sh
resource "aws_subnet" "subnets" {
  for_each = { for idx, subnet in var.subnets : idx => subnet }
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.az
  map_public_ip_on_launch = each.value.public
  tags = { Name = "subnet-${each.key}" }
}
```
### 6. Set Up NAT Gateway

Allocate an Elastic IP and create a NAT gateway:
```sh
resource "aws_eip" "nat" { domain = "vpc" }
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.subnets[0].id
  tags = { Name = "nat-gateway" }
}
```
### 7. Create Security Group
```sh
Define security rules to allow SSH and HTTP access:

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
```
### 8. Deploy EC2 Instances for Web and App Servers

Define EC2 instances for Nginx and Apache:
```sh
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
```
### 9. Define Output Values

Add outputs to retrieve public and private IPs:
```sh
output "web_server_public_ip" {
  value = aws_instance.web_server.public_ip
}

output "app_server_private_ip" {
  value = aws_instance.app_server.private_ip
}
```
### 10. Set Up Variables

Define Variables in variables.tf
```sh
variable "region" {}
variable "vpc_cidr" {}
variable "subnets" {}
```
Assign Values in terraform.tfvars
```sh
region = "us-east-1"
vpc_cidr = "10.0.0.0/16"
subnets = {
  public = { cidr_block = "10.0.1.0/24", az = "us-east-1a", public = true }
  private = { cidr_block = "10.0.2.0/24", az = "us-east-1b", public = false }
}
```
### 11.Add User Data Scripts

Nginx User Data Script (user_data_nginx.sh)
```sh
#!/bin/bash
sudo yum update -y
sudo amazon-linux-extras enable nginx1
sudo yum install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```
Apache User Data Script (user_data_apache.sh)
```sh
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
```
### 12. Validate and Deploy Infrastructure

Format and Validate Configuration
```sh
terraform fmt
terraform validate
```
Preview Changes
```sh
terraform plan
```
![Image](https://github.com/user-attachments/assets/5b0600f0-9776-4c54-872b-54d7f899c5f7)

Apply Changes
```sh
terraform apply -auto-approve
```

![Image](https://github.com/user-attachments/assets/2585cf5d-c5e4-46f7-9986-ce6b6658186e)

![Image](https://github.com/user-attachments/assets/e194e34a-7c8c-45fa-9268-737eac947691)

![Image](https://github.com/user-attachments/assets/83eec81b-b3e3-41bb-a1f9-b55b421b878b)
