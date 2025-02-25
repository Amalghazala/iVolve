Lab 1: User and Group Management
First, create a new group called ghazala:
sudo groupadd ghazala
Create a New User and Add to the Group:
sudo useradd -m -G ghazala -s /bin/bash amal
Set a password for the user:
sudo passwd username
Run the following command to edit the sudoers file:
sudo visudo
add this line to allow amal in the ghazala group to run sudo yum install nginx without a password.
amal ALL=(ALL) NOPASSWD: /usr/bin/yum install nginx
switch to amal:
su - amal
Run this command and it shouldn't ask for a password:
sudo yum install nginx
![Image](https://github.com/user-attachments/assets/73ea2a77-da59-4484-bc56-a867b9d9eb69)
and if amal try running another command will ask for a password:
![Image](https://github.com/user-attachments/assets/b5aaa0e2-11e8-48eb-95c3-e41154857f9d)
