# Lab 13: Create AWS Load Balancer
---
### 1. Create a VPC
   * Open the AWS Management Console.
   * Navigate to VPC Dashboard.
   * Click Create VPC.
   * Configure the VPC:
     * Name: MyVPC
     * IPv4 CIDR Block: 10.0.0.0/16
     * Tenancy: Default
     * Click Create VPC.

       ![Image](https://github.com/user-attachments/assets/0410857e-9b17-446f-adf5-cc07002137fd)

### 2. Create Two Subnets:
* Create the First Subnet (PublicSubnet1):
  * Go to VPC Dashboard → Click Subnets.
  * Click Create Subnet.
  * Configure:
    * Name: PublicSubnet1
    * VPC: MyVPC
    * IPv4 CIDR Block: 10.0.1.0/24
    * Availability Zone: Choose one (e.g., us-east-1a)
  * Click Create Subnet
* Create the Second Subnet (PublicSubnet2):
  * Click Create Subnet again.
  * Configure:
    * Name: PublicSubnet2
    * VPC: MyVPC
    * IPv4 CIDR Block: 10.0.2.0/24
    * Availability Zone: Choose a different one (e.g., us-east-1b)
* Click Create Subnet.
  
  ![Image](https://github.com/user-attachments/assets/2fb2628d-10ca-4808-9f54-6a64a0416ee9)

### 3. Attach an Internet Gateway
*  Create and Attach an Internet Gateway
  * Go to VPC Dashboard → Click Internet Gateways.
  * Click Create Internet Gateway.
  * Set:
    * Name: MyIGW
  * Click Create.
  * Attach it to MyVPC:
    * Select MyIGW → Click Actions → Attach to VPC → Select MyVPC.

    ![Image](https://github.com/user-attachments/assets/b3c94ad5-23f1-489f-9ad5-0e547fffc6d8)

### 4. Configure Route Tables
*  Create a Public Route Table
  * Go to VPC Dashboard → Click Route Tables.
  * Click Create Route Table.
  * Set:
    * Name: PublicRouteTable
    * VPC: MyVPC
  * Click Create.
  * Select PublicRouteTable, go to Routes → Click Edit Routes.
  * Add a new route:
    * Destination: 0.0.0.0/0
    * Target: MyIGW
  * Click Save Changes.
* Associate the Route Table with Both Public Subnets
  * In Route Tables, select PublicRouteTable.
  * Go to Subnet Associations → Click Edit Subnet Associations.
  * Select:
    * PublicSubnet1
    * PublicSubnet2
  * Click Save Associations.

  ![Image](https://github.com/user-attachments/assets/7c0fbf0d-4ffc-4301-a83e-b2867d03e47b)

### 5. Launch Two EC2 Instances:
* Launch EC2 Instance 1 (nginx)
  * Go to EC2 Dashboard → Click Launch Instance.
  * Configure:
    * Name: nginx
    * AMI: Amazon Linux 2
    * Instance Type: t2.micro
    * select or create a key pair
    * VPC: MyVPC
    * Subnet: PublicSubnet1
    * Auto-assign Public IP: Enabled
  * Create a security group Web-SG:
    * Allow HTTP (80) from Anywhere (0.0.0.0/0).
    * Allow SSH (22) from Your IP.
  * Click Launch
  * SSH into the instance and install nginx:
    ```sh
    sudo yum update -y
    sudo amazon-linux-extras enable nginx1
    sudo yum install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    ```
* Launch EC2 Instance 2 (Apache)
  * Repeat the steps above, but change:
    * Name: Apache
    * Subnet: PublicSubnet2
  * SSH into the instance and install Apache:
    ```sh
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd
    ```
  ![Image](https://github.com/user-attachments/assets/16c2ef1e-d3a8-4632-bb2e-db30eac020b6)

### 6. Create an Application Load Balancer:
*  Create an AWS Load Balancer
  * Go to EC2 Dashboard → Load Balancers.
  * Click Create Load Balancer.
  * Select Application Load Balancer.
  * Configure:
    * Name: MyALB
    * Scheme: Internet-facing
    * VPC: MyVPC
    * Subnets: PublicSubnet1, PublicSubnet2
  * Click Create Load Balancer.
    
  ![Image](https://github.com/user-attachments/assets/ac677220-800e-4d13-b109-fe6321d19144)

* Create Security Group for Load Balancer
  * Create a new security group ALB-SG
    * Allow HTTP (80) from Anywhere (0.0.0.0/0).
  * Click create .
    
  ![Image](https://github.com/user-attachments/assets/a46c3956-6846-485c-b92b-3a4dcc87ac8b)

* Create Target Group
  * Create a new target group:
    * Target Type: Instance
    * Protocol: HTTP
    * Port: 80
    * VPC: MyVPC
  * Register both WebServer1 and WebServer2 as targets.
  * Click create
    
  ![Image](https://github.com/user-attachments/assets/ef4ce0e6-f62d-485c-93e3-ad0e00a3ef0d)

### 7. Test the Load Balancer
   * Copy the DNS name of the Load Balancer from the EC2 Console.
   * Open a browser and visit:
     ```sh
     http://mylab-578570794.us-east-1.elb.amazonaws.com
     ```
   * Refresh multiple times to see traffic switching between nginx and Apache.
     
   ![Image](https://github.com/user-attachments/assets/b45ae8f9-fb0a-40c7-964b-a6c168478022)

![Image](https://github.com/user-attachments/assets/0d6dc4e3-7a23-41ab-a12b-9c6121f00a3c)

    


















  
      


   





