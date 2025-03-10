# Lab 21: Role-based Authorization in Jenkins
---
### 1. Install the Role Strategy Plugin:
   * Log in to Jenkins
   * Go to "Manage Jenkins" → "Manage Plugins"
     * Go to the Available tab.
     * Search for "Role-based Authorization Strategy".
     * Select it and click Install without restart.

### 2. Enable Role-based Strategy
   * Go to "Manage Jenkins" → "Security"
     * Under Authorization, select Role-Based Strategy.
     * Click Save.

### 3. Create Users:
   * Create user1 (Admin)
   * Go to Manage Jenkins → Manage Users → Create User.
     * Username: user1
     * Password: *****
     * Full Name: user1
     * Email: user1@example.com
     * Click Create User
   * Create user2 (Read-Only)
   * Repeat the same steps for user2.
     * Username: user2
     * Full Name: user2
     * Give a different password.
       
   ![Image](https://github.com/user-attachments/assets/effa248c-5978-4a38-b7ed-f0c4f257b545)

### 4. Configure Roles:
   * Go to Manage Jenkins → Manage and Assign Roles.
   * Define Roles:
     * Go to Manage Roles → Click Add Role.
     * Create two roles:
       * Admin → admin role (user1)
       * Read-Only → read_only role (user2)
     * Click Save.
       
   ![Image](https://github.com/user-attachments/assets/467d16c2-256f-47a0-bb82-c2e1b795a785)

   * Assign Roles:
     * Go to Assign Roles.
     * Assign user1 to the Admin role.
     * Assign user2 to the Read-Only role.
     * Click Save.
       
    ![Image](https://github.com/user-attachments/assets/0a71c84e-a28e-4be6-adc0-2c4cedca4df3)

### 5. Test User Permissions:
   *  Log out from Jenkins.
   *  Log in as user1 → Should have full access.
     
     ![Image](https://github.com/user-attachments/assets/ea07afc6-7d07-493e-b0a5-e9dc6bbb182c)
  
   *  Log in as user2 → Should only have read-only access.
     
     ![Image](https://github.com/user-attachments/assets/2c312156-0ce2-42df-ac5b-46a186d0fde4)
     




   
