# Jenkins Pipeline for Application Deployment

## Prerequisites
- **Jenkins Installed on Local Host**: Jenkins was installed and configured on the local machine.
- **Kubernetes Installed on EC2 Instance**: Kubernetes was set up on an AWS EC2 instance.
- **SSH Access to EC2**: The EC2 instance was accessed from the local host using SSH.

![Image](https://github.com/user-attachments/assets/f93cea31-38b4-4a99-bef3-897fc3547b33)

- **Docker and Kubernetes CLI installed** on both local and EC2 instances.
- **Git and GitHub account** configured.
- **Docker Hub account** for pushing the image.

![Image](https://github.com/user-attachments/assets/46bf0402-854c-408b-832c-67c48c161e0a)

- **Jenkins Plugins Installed**: Docker Plugin and Kubernetes CLI Plugin.
  
![Image](https://github.com/user-attachments/assets/278e7be8-bb4e-4fd7-a822-07ab05d4f8ec)

![Image](https://github.com/user-attachments/assets/f9c8f063-32ce-4e10-9c81-d873f4937869)

- **Jenkins Credentials Created**:
  - **Username and Password** credential named `ubuntu`.
  - **SSH Username with Private Key** credential named `k8s-ssh`.
  - 
![Image](https://github.com/user-attachments/assets/fa9f3332-e489-49fc-8c66-1de02cf9681c)

## Steps to Automate the Deployment Pipeline

### Step 1: Configure Jenkins Pipeline
1. Open **Jenkins Dashboard** and navigate to **New Item**.
2. Select **Pipeline**, name it "lab22", and click **OK**.

### Step 3: Create `deployment.yaml`
Add the following content to `deployment.yaml`:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app1-deployment
  labels:
    app: app1
spec:
  replicas: 2  # Number of pods
  selector:
    matchLabels:
      app: app1
  template:
    metadata:
      labels:
        app: app1
    spec:
      containers:
      - name: app1-container
        image: amalghazala11/lab22-image:v1.0
        ports:
        - containerPort: 80  # Port the container listens on
---
apiVersion: v1
kind: Service
metadata:
  name: app1-service
spec:
  selector:
    app: app1
  ports:
    - protocol: TCP
      port: 80  # Port to expose service
      targetPort: 80
  type: LoadBalancer  # Use ClusterIP, NodePort, or LoadBalancer based on your setup
```

### Step 4: Create a `Jenkinsfile`
Add the following script to `App1/Jenkinsfile`:
```groovy
pipeline {
    agent any
    environment {
        DEPLOYMENT_FILE = "deployment.yaml"
        K8S_REMOTE_SERVER = "18.215.157.247"
        K8S_USER = "ubuntu"
        DOCKER_IMAGE = "amalghazala11/lab22-image:v1.0"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/IbrahimAdell/App1.git', branch: 'main'
            }
        }

        stage('Docker image Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'ubuntu', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh """
                    docker build . -t ${USERNAME}/lab22-image:v1.0
                    docker login -u ${USERNAME} -p ${PASSWORD}
                    docker push ${USERNAME}/lab22-image:v1.0
                    docker rmi ${USERNAME}/lab22-image:v1.0
                    """
                }
            }
        }
        stage('Update Deployment File') {
            steps {
                sh """
                pwd
                ls -l
                sed -i 's|image: .*|image: ${DOCKER_IMAGE}|' ${DEPLOYMENT_FILE}
                """
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'k8s-ssh', keyFileVariable: 'SSH_KEY')]) {
                sh """
                chmod 600 $SSH_KEY
                scp -o StrictHostKeyChecking=no -i $SSH_KEY ${DEPLOYMENT_FILE} ${K8S_USER}@${K8S_REMOTE_SERVER}:/home/${K8S_USER}/
                ssh -o StrictHostKeyChecking=no -i $SSH_KEY ${K8S_USER}@${K8S_REMOTE_SERVER} "kubectl apply -f /home/${K8S_USER}/${DEPLOYMENT_FILE}"
                """
                }
            }
        }
    }
    post {
        always {
            echo 'Pipeline execution completed!'
        }
        success {
            echo 'Deployment was successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
```


### Step 5: Run the Pipeline
1. In **Jenkins**, navigate to **lab22**.
2. Click **Build Now** to execute the pipeline.
3. Monitor the console output for progress.

![Image](https://github.com/user-attachments/assets/2ceca92b-0807-4fb7-9af1-e3385c87a365)

### Step 6: Verify Deployment on Kubernetes
```bash
kubectl get pods -o wids
kubectl get services
kubectl get deployments
```
![Image](https://github.com/user-attachments/assets/14561c60-f0e1-4395-9164-98a3d521d427)

![Image](https://github.com/user-attachments/assets/cecc2021-8d10-4c52-9d64-169b372cfb8e)

![Image](https://github.com/user-attachments/assets/f58a5c81-9b41-4ef9-8c7e-026bbfdacd72)

Then, open the application in a browser using `http://18.215.157.247:30435.

![Image](https://github.com/user-attachments/assets/b3ef8f57-d976-495b-80b1-06a0db3c9951)

