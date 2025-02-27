Lab 6: Ansible Installation

1. Ensure the Managed Node is Running using:

   ssh student@servera

2. Install Ansible on the Control Node using:

      sudo dnf update -y
   
      sudo dnf install -y ansible

    2.1. Verify installation:

       ansible --version

4. Configure the Ansible Inventory using:

   sudo nano /etc/ansible/hosts

   ![Image](https://github.com/user-attachments/assets/42d4745f-acb4-4519-a4e2-b2af5b252ea6)

   3.1. Ensure correct permissions:

        sudo chmod 644 /etc/ansible/hosts

5. Run Ad-Hoc Ansible Commands

   ![Image](https://github.com/user-attachments/assets/dd852be7-6b1d-4ea3-a90c-3bb67e48467a)





