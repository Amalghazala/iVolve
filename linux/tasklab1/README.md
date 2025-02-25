Lab 1: User and Group Management

1. First, create a new group and a new user c to Add to the Group:

sudo groupadd ghazala

sudo useradd -m -G ghazala -s /bin/bash amal


2. Set a password for the user:

sudo passwd username

3. Run the following command to edit the sudoers file:

sudo visudo

then add this line to allow amal in the ghazala group to run sudo yum install nginx without a password.:

amal ALL=(ALL) NOPASSWD: /usr/bin/yum install nginx

4. switch to amal:

su - amal

amal user will be able to install nginx without asking for password

![Image](https://github.com/user-attachments/assets/b5aaa0e2-11e8-48eb-95c3-e41154857f9d)

and if amal try running another command will ask for a password:

![Image](https://github.com/user-attachments/assets/73ea2a77-da59-4484-bc56-a867b9d9eb69)
