# Lab 20: Jenkins Installation
---
### 1. Verify Docker version:

   ```sh
   docker --version
  ```
### 2. Run Jenkins Container
   
   * Create a Jenkins volume:
     ```sh
     docker volume create jenkins_data
     ```
   * Run Jenkins container:
     ```sh
     docker run -d --name jenkins \
       -p 8080:8080 -p 50000:50000 \
       -v jenkins_data:/var/jenkins_home \
       -v /var/run/docker.sock:/var/run/docker.sock \
       jenkins/jenkins:lts
       ```
     ![Image](https://github.com/user-attachments/assets/bf2372b6-cc4a-46cb-8f84-97b1d15a399b)

### 3. Get Initial Admin Password:
   
   Jenkins needs an initial password to complete the setup. Get it by running:
   ```sh
   docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   ```
  Copy this password.

### 4. Access Jenkins Web UI:
 * Open your browser and go to: 
    ```sh
    http://172.17.0.1:8080
    ```
 * Choose "Install Suggested Plugins".
 * Create an admin user and complete the setup.

   ![Image](https://github.com/user-attachments/assets/037c23fe-c036-4efd-9a67-f25bbec7a097)
   
   ![Image](https://github.com/user-attachments/assets/997f515d-6108-4282-acd5-854d5004478c)




   
           
  


    



