lab5 SSH Key-Based Authentication & Configuration:

1. Verify SSH is Running on Both Machines using:

   sudo systemctl status sshd

   ![Image](https://github.com/user-attachments/assets/eb123764-2c1a-44ca-ba4c-8132da0f89f5)

2. Find the IP Address of the Target Machine using:

   ip a
   
3. Generate SSH Keys on the Source Machine:

   ![Image](https://github.com/user-attachments/assets/8b129176-444f-42ab-89cb-38874a1dc7ff)

4. Copy the SSH Key to the Target Machine using:

   ssh-copy-id student@servera

5. Test SSH Connection Without a Password using:

   ssh student@servera

6. Configure ~/.ssh/config for Simplified Access using:

   nano ~/.ssh/config

   ![Image](https://github.com/user-attachments/assets/5e3f018f-553a-4787-adfc-d4e3c7283977)

7. Ensure correct file permissions then Test the Connection Using the Alias:

   ![Image](https://github.com/user-attachments/assets/312ce6b5-60b5-4831-a38d-4f2bb21ce298)
