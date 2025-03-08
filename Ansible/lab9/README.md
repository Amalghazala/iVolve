# **Lab 9: Ansible Roles for Application Deployment**
___

### **Overview:**

This project uses Ansible to automate the installation and configuration of Jenkins, Docker, and OpenShift CLI (oc) on ServerA. The playbook and roles are structured to ensure a modular deployment, following best practices for automation.

#### 1. Set Up Ansible Directory :

![Image](https://github.com/user-attachments/assets/7d26a2f2-d741-4495-932a-e03d2fb0ee61)

* mkdir ~/ansible → Creates a directory named ansible in the home directory to store Ansible-related files.
* cd ~/ansible → Navigates into the ansible directory.

#### 2. Verify Ansible Installation :

![Image](https://github.com/user-attachments/assets/e35e1d1b-3d54-44ce-afd3-18db7ae8c33b)

#### 3. Create Ansible Roles :

![Image](https://github.com/user-attachments/assets/0670806b-a60e-41d4-ac02-78269c5585cc)

```sh
roles/
├── jenkins/
│   ├── tasks/main.yml
├── docker/
│   ├── tasks/main.yml
├── oc/
│   ├── tasks/main.yml
```


#### 4. Define Inventory File :

![Image](https://github.com/user-attachments/assets/020feeac-973f-4f9b-9503-88c16b6f616b)

#### 5. Write the Playbook :

![Image](https://github.com/user-attachments/assets/4b5f9b08-6d21-4df3-b07b-21240c5ad0d5)

#### 5. Define Role Tasks :

**Jenkins Role** (roles/jenkins/tasks/main.yml)

![Image](https://github.com/user-attachments/assets/65e6f897-0e30-42a4-b9b9-9ea7dde7d7f8)

* Installs Java (required for Jenkins)
* Adds Jenkins repository and installs Jenkins
* Starts and enables Jenkins service


**Docker Role** (roles/docker/tasks/main.yml)

![Image](https://github.com/user-attachments/assets/dd46c58f-6beb-485f-9338-0fb4da4775a4)

* Installs Docker
* Starts and enables Docker service
* Adds student user to the docker group


**OpenShift CLI Role** (roles/oc/tasks/main.yml)

![Image](https://github.com/user-attachments/assets/9c25715a-9d30-4510-bf68-1189cf2b8c07)

* Installs oc CLI for managing OpenShift

#### 5. Run the Playbook :

![Image](https://github.com/user-attachments/assets/da8e99ad-5e19-4f5e-bce7-1f0f734ac9ce)

* Install and configure Jenkins.
* Install and configure Docker.
* Install OpenShift CLI (oc).

#### 5. Verification :

After running the playbook, check:

**Jenkins status:**

![Image](https://github.com/user-attachments/assets/8a2645fc-4ec0-4a3b-8923-fe18f93d5083)

**Docker status:**

![Image](https://github.com/user-attachments/assets/1e25c8eb-cf72-460b-ab1b-ee6aeb3ee21d)

**OpenShift CLI version:**

![Image](https://github.com/user-attachments/assets/0d15b373-0f15-48bc-8843-0e009dbcd13d)






















