Lab 8: Ansible Vault

1. Ansible Installed:

   Ensure Ansible is installed on your workstation. You can check the version using:

   ```sh
   ansible --version

2. Connectivity to servera:

   Verify that servera is reachable from your workstation:

   ```sh
   ping servera

3. Creating an Encrypted File with Ansible Vault:
   
   To store sensitive information securely, we use Ansible Vault to create a file 'secrets.yml'

   ![Image](https://github.com/user-attachments/assets/161e1454-6321-44c9-9a24-88355f3f2cd2)

   ![Image](https://github.com/user-attachments/assets/94e23445-6da4-4ff9-8c4d-0c35b15646e5)

5. Writing the Ansible Playbook (mysql_setup.yml):

   The playbook automates the installation of MySQL, database creation, and user management.

   ![Image](https://github.com/user-attachments/assets/3536a4b5-7f68-4cc9-bab6-4c78d08a3bca)


6. Running the Playbook:

   ```sh
   ansible-playbook --ask-vault-pass --ask-become-pass -i /etc/ansible/hosts mysql_setup.yml


![Image](https://github.com/user-attachments/assets/d7f9395b-ed40-4665-b713-46e6f79f9855)

7. Verifying the Database and User Creation:

   After execution, log into MySQL on servera to verify the changes:

   ```sh
   mysql -u ivolve_user -p
   SHOW DATABASES;   
   

![Image](https://github.com/user-attachments/assets/7b9a1055-1833-4180-8b7c-c8e8bd92d8a9)








   


