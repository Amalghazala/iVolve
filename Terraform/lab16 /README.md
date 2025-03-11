# Lab 16 : Multi-Tier Application Deployment with Terraform
---
## Objective

This lab demonstrates how to deploy a multi-tier application using Terraform on AWS Cloud9. It involves:
   * Setting up an AWS Cloud9 development environment.
   * Creating a VPC manually.
   * Making Terraform manage the VPC.
   * Implementing the architecture as shown in the diagram.
   * Using a local provisioner to store the EC2 public IP in a file ec2-ip.txt.

---
1. Set Up AWS Cloud9 Environment
   * Log in to the AWS Console and create a Cloud9 environment.
   * Create the vpc manually

2. Install Terraform
   ```sh
   sudo yum install -y yum-utils
   sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
   sudo yum install -y terraform
   terraform version
   ```
   ![Image](https://github.com/user-attachments/assets/4f8d58be-b97d-49b1-ba6e-491f36e5b797)

3. Write Terraform Configuration:
   ```sh
    provider "aws" {
      region = "us-east-1"
    }
    resource "aws_vpc" "MyTerraformVPC" {
      cidr_block = "10.0.0.0/16"
      tags = {
        Name = "MyTerraformVPC"
     }
   }
    ```
* Initialize Terraform

  This initializes the Terraform working directory and downloads necessary provider plugins

   ```sh
   terraform init
   ```

![419704779-81de415a-e607-4001-94b3-63a1daaaf297m](https://github.com/user-attachments/assets/a043f4af-86d1-45cf-8b0d-3f69bb6bf045)

* Import the Existing VPC
  ```sh
  terraform import aws-vpc.MyTerraformVPC vpc-008bfc94fbec2adc7
  ```

  ![Image](https://github.com/user-attachments/assets/3de86821-9b9b-4bf2-abb4-a818a21497ff)



* Create Public and Private Subnets:
  
  ```sh
  resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.MyTerraformVPC.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "TerraformPublicSubnet"
  }
  }
  resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.MyTerraformVPC.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "TerraformPrivateSubnet1"
  }
  }
  resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.MyTerraformVPC.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "TerraformPrivateSubnet2"
  }
  }
  ```


* Create an Internet Gateway:
  
  ```sh
  resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.MyTerraformVPC.id

  tags = {
    Name = "TerraformIGW"
  }
  }
  ```

* Create a Route Table for Public Subnet:
  
  ```sh
  resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.MyTerraformVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "TerraformPublicRouteTable"
  }
  }
  ```

* Associate the Route Table with the Public Subnet:
  
  ```sh
  resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
  }
  ```

* Security Group for EC2
  
  ```sh
  resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.MyTerraformVPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
    Name = "TerraformWebSG"
  }
  }
  ```

* Security Group for RDS

  ```sh
  resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.MyTerraformVPC.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TerraformRDSSG"
  }
  }
  ```
* Create an EC2 Instance in the Public Subnet:

  ```sh
  resource "aws_instance" "ec2_instance" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "TerraformEC2"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ec2-ip.txt"
  }
  }
  ```
* Create RDS Subnet Group:

  ```sh
  resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "terraform-rds-subnet-group"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  tags = {
    Name = "TerraformRDSSubnetGroup"
  }
  }
  ```

* Create an RDS Instance in the Private Subnets:

  ```sh
  resource "aws_db_instance" "rds_instance" {
  identifier         = "terraform-rds"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  db_name           = "mydatabase"
  username         = "admin"
  password         = "Terraform123!"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = {
    Name = "TerraformRDS"
  }
  }
  ```


* Plan the Deployment
   ```sh
   terraform plan
   ```
This shows the execution plan and resources to be created.

![Image](https://github.com/user-attachments/assets/ea0db98d-8adf-4397-85b2-e11dd9abbd4a)

*  Apply the Terraform Configuration
  ```sh
terraform apply -auto-approve
```
* After deployment, the EC2 public IP is stored in ec2-ip.txt
  




