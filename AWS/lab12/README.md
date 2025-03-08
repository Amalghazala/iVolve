# **Lab 12: Launching an EC2 Instance**
___
## **Overview**

This lab guides you through the process of setting up an AWS environment with a Virtual Private Cloud (VPC) that contains both public and private subnets. You will launch an EC2 instance in each subnet, configure security groups to restrict access, and use a bastion host to securely connect to the private instance. By the end of this lab, you will have a structured cloud network with controlled SSH access.

---
### **1. Create a VPC:**
   * Navigate to the AWS VPC Console.
   * Click Create VPC.
   * Select VPC only.
   * Set:
     * Name tag: MyLapVPC
     * IPv4 CIDR Block: 10.0.0.0/16
     * IPv6 CIDR Block: None
     * Tenancy: Default
   * Click Create VPC.
     
![Image](https://github.com/user-attachments/assets/226427cf-2914-4447-ae5f-a22575bb4a84)

### **2. Create Subnets:**
**Public Subnet**
   * Navigate to Subnets in the VPC Console.
   * Click Create subnet.
   * Select MyLapVPC.
   * Set:
     * Subnet name: PublicSubnet
     * IPv4 CIDR Block: 10.0.1.0/24
     * Availability Zone: Choose one (ex: us-east-1a)
  * Click Create subnet..
**Private Subnet**
   * Repeat the fisrt two steps
   * Set:
     * Subnet name: PrivateSubnet
     * IPv4 CIDR Block: 10.0.2.0/24
     * Availability Zone: Choose one (e.g.: us-east-1b)
   * Click Create subnet.

### **3. Create and Attach an Internet Gateway:**
   * Navigate to Internet Gateways.
   * Click Create Internet Gateway.
   * Set:
     * Name tag: MyIGW
   * Click Create internet gateway.
   * Select MyIGW and click Attach to VPC.
   * Select MyLabVPC and click Attach internet gateway.
     
![Image](https://github.com/user-attachments/assets/458667de-35e5-49c1-a056-1a8829f535d8)

### **4. Configure Route Tables:**
**Public Route Table**
   * Navigate to Route Tables.
   * Click Create route table.
   * Set:
     * Name: PublicRouteTable
     * VPC: MyLabVPC
   * Click Create route table.
   * Select the PublicRouteTable, go to Routes tab, and click Edit routes.
   * Add a new route:
     * Destination: 0.0.0.0/0
     * Target: MyIGW 
   * Click Save changes.
   * Navigate to Subnet Associations, click Edit subnet associations, and select PublicSubnet.
   * Click Save associations.

### **5. Launch EC2 Instances:**
**Public EC2 Instance (Bastion Host)**
   * Navigate to EC2 Console.
   * Click Launch Instance.
   * Configure:
     * Name: PublicEC2
     * AMI: Amazon Linux 2
     * Instance Type: t2.micro
     * VPC: MyVPC
     * Subnet: PublicSubnet
     * Auto-assign Public IP: Enabled
   * Create a new security group Public-EC2-SG:
     *Allow SSH (22) from Anywhere (0.0.0.0/0).
   * Click Launch

**Private EC2 Instance**
   * Repeat the steps for the public instance, but:
     * Select PrivateSubnet.
     * Auto-assign Public IP: Disable
   * Create a new security group Private-EC2-SG: 
     * Allow SSH (22) from PublicEC2 Private IP only.
   * Click Launch
       
![Image](https://github.com/user-attachments/assets/5be1116f-eaca-44d5-802f-4a3215c6ae37)

![Image](https://github.com/user-attachments/assets/0d24aeb9-7c8e-434d-a894-c8d6a019fa5f)

### **6. SSH into the Private Instance via Bastion Host**
   * Connect to the Bastion Host:
     ```sh
     ssh -i my-key.pem ec2-user@54.158.29.175
     ```
![Image](https://github.com/user-attachments/assets/be504c2f-d38a-474a-a107-fe8b9fe0a8d4)

   * From the public instance, SSH into the private instance:
     ```sh
     ssh -i my-key.pem ec2-user@10.0.2.63
     ```
  





   


   





  






