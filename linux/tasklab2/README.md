lab2: Shell scripting basics 

1. first install mySQL and secure its installation:
   
   sudo yum update && sudo yum install mysql-server -y
   
   sudo mysql_secure_installation

3. Create a database and user and give him permissions:

   ![Image](https://github.com/user-attachments/assets/d247dd9e-3308-489e-80a9-d1a48696b57f)

4.  Create a Backup Script then give the script execution permissions:
   
    sudo nano /usr/local/bin/mysql_backup.sh

    ![Image](https://github.com/user-attachments/assets/64b537d2-5a4a-457a-b671-d0ad6d49546f)

    ![Image](https://github.com/user-attachments/assets/f34743b9-fed4-4d7f-83e6-f8755a35b407)
    

5. Schedule a Cron Job for Weekly Backups and edit the corn jobs for the user root then check the backup folder:
   
   ![Image](https://github.com/user-attachments/assets/e9436dbe-82b1-4882-9b07-fc86d5775bd5)

   ![Image](https://github.com/user-attachments/assets/d9f81695-82df-4edb-b124-d90597b0a393)

  
