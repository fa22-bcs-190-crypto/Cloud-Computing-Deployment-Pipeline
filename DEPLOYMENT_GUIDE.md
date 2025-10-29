# 📋 Complete Deployment Guide

## Step-by-Step Instructions for Cloud Computing Pipeline

### Prerequisites

Before starting, ensure you have:
- Node.js (v16 or higher)
- Docker Desktop
- Azure CLI
- kubectl
- Git
- Docker Hub account
- Azure subscription

## 🔧 Section 1: Local Development & Docker (10 Marks)

### Step 1: Run App Locally (2 marks)

1. **Clone and Setup**:
   ```bash
   git clone <your-repo-url>
   cd cloud-deployment-pipeline
   npm install
   ```

2. **Start MongoDB**:
   ```bash
   docker run -d --name mongodb -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=password123 mongo:7.0
   ```

3. **Start Application**:
   ```bash
   npm start
   ```

4. **Verify Local Deployment**:
   - Open browser: http://localhost:3000
   - Test API: http://localhost:3000/api/tasks
   - Health check: http://localhost:3000/health

**Screenshot Required**: Browser showing the application running on localhost:3000

### Step 2: Create Dockerfile (3 marks)

The Dockerfile is already created with:
- Multi-stage build
- Security best practices
- Health checks
- Production optimization

**Key Features**:
- Uses Node.js Alpine image
- Non-root user execution
- Optimized layer caching
- Health check endpoint

### Step 3: Build and Run Docker Container (3 marks)

1. **Build Docker Image**:
   ```bash
   docker build -t cloud-pipeline-app .
   ```

2. **Run Container**:
   ```bash
   docker run -d --name app-container -p 3001:3000 cloud-pipeline-app
   ```

3. **Test Container**:
   ```bash
   curl http://localhost:3001/health
   ```

4. **Using Docker Compose** (Recommended):
   ```bash
   docker-compose up -d
   ```

**Screenshots Required**: 
- Docker build success
- Container running successfully

### Step 4: Push to Docker Hub (2 marks)

1. **Login to Docker Hub**:
   ```bash
   docker login
   ```

2. **Tag Image**:
   ```bash
   docker tag cloud-pipeline-app your-dockerhub-username/cloud-pipeline-app:latest
   ```

3. **Push Image**:
   ```bash
   docker push your-dockerhub-username/cloud-pipeline-app:latest
   ```

**Screenshot Required**: Docker Hub repository showing the pushed image

## ☁️ Section 2: Azure Kubernetes Deployment (10 Marks)

### Step 1: Create Azure Kubernetes Cluster (3 marks)

1. **Login to Azure**:
   ```bash
   az login
   ```

2. **Create Resource Group**:
   ```bash
   az group create --name cloud-pipeline-rg --location eastus
   ```

3. **Create AKS Cluster**:
   ```bash
   az aks create \
     --resource-group cloud-pipeline-rg \
     --name cloud-pipeline-aks \
     --node-count 2 \
     --enable-addons monitoring \
     --generate-ssh-keys
   ```

4. **Get Credentials**:
   ```bash
   az aks get-credentials --resource-group cloud-pipeline-rg --name cloud-pipeline-aks
   ```

**Screenshot Required**: Azure portal showing the created AKS cluster

### Step 2: Deploy Containerized App (4 marks)

1. **Update Deployment File**:
   Edit `k8s/app-deployment.yaml` and replace:
   ```yaml
   image: your-dockerhub-username/cloud-pipeline-app:latest
   ```

2. **Deploy to Kubernetes**:
   ```bash
   kubectl apply -f k8s/namespace.yaml
   kubectl apply -f k8s/mongodb-deployment.yaml
   kubectl apply -f k8s/app-deployment.yaml
   ```

3. **Verify Deployment**:
   ```bash
   kubectl get pods -n cloud-pipeline
   kubectl get services -n cloud-pipeline
   ```

4. **Check Logs**:
   ```bash
   kubectl logs -f deployment/cloud-pipeline-app -n cloud-pipeline
   ```

**Screenshots Required**: 
- kubectl get pods showing running pods
- kubectl get services showing services

### Step 3: Expose via Public IP (3 marks)

1. **Get External IP**:
   ```bash
   kubectl get service cloud-pipeline-service -n cloud-pipeline -w
   ```
   Wait until EXTERNAL-IP is assigned (not <pending>)

2. **Access Application**:
   - Copy the EXTERNAL-IP
   - Open browser: http://[EXTERNAL-IP]/

3. **Test Public Access**:
   - Verify the application loads
   - Test task creation/deletion
   - Check health endpoint: http://[EXTERNAL-IP]/health

**Screenshot Required**: Browser showing the application running on the public IP

## 💻 Section 3: GitHub Repository (5 Marks)

### Step 1: Create GitHub Repository (1 mark)

1. **Create Repository on GitHub**:
   - Go to github.com
   - Click "New repository"
   - Name: "cloud-deployment-pipeline"
   - Make it public
   - Don't initialize with README (we have one)

### Step 2: Add All Files (2 marks)

1. **Initialize Git** (if not done):
   ```bash
   git init
   ```

2. **Add Remote**:
   ```bash
   git remote add origin https://github.com/your-username/cloud-deployment-pipeline.git
   ```

3. **Add Files**:
   ```bash
   git add .
   ```

4. **Commit**:
   ```bash
   git commit -m "Initial commit: Complete cloud deployment pipeline with Docker and Kubernetes"
   ```

**Screenshot Required**: GitHub repository showing all committed files

### Step 3: Git Commands Usage (2 marks)

Demonstrate proper Git workflow:

```bash
# Check status
git status

# Add specific files
git add server.js
git add public/

# Commit with meaningful message
git commit -m "Add task management functionality"

# Push to GitHub
git push -u origin main

# Pull latest changes
git pull origin main

# View commit history
git log --oneline

# Check differences
git diff

# Create and switch branch
git checkout -b feature/improvements

# Merge branch
git checkout main
git merge feature/improvements
```

## 📋 Submission Checklist

### Required Links:
- [ ] GitHub Repository URL
- [ ] Docker Hub Image URL
- [ ] Azure App Public URL

### Required Screenshots:
- [ ] Local application running (localhost:3000)
- [ ] Docker build success
- [ ] Docker Hub repository with image
- [ ] Azure AKS cluster in portal
- [ ] kubectl get pods output
- [ ] kubectl get services output
- [ ] Public application access via external IP
- [ ] GitHub repository with all files

### Verification Steps:
- [ ] Application runs locally
- [ ] Docker container works
- [ ] Image pushed to Docker Hub
- [ ] AKS cluster created
- [ ] Application deployed to AKS
- [ ] Public IP accessible
- [ ] All files in GitHub
- [ ] Git commands demonstrated

## 🛠️ Troubleshooting Common Issues

### Local Development Issues:

1. **Port 3000 already in use**:
   ```bash
   netstat -ano | findstr :3000
   taskkill /PID <PID> /F
   ```

2. **MongoDB connection failed**:
   ```bash
   docker ps
   docker logs mongodb
   ```

### Docker Issues:

1. **Build fails**:
   - Check Dockerfile syntax
   - Ensure package.json exists
   - Verify file permissions

2. **Container won't start**:
   ```bash
   docker logs <container-id>
   ```

### Kubernetes Issues:

1. **Pods stuck in Pending**:
   ```bash
   kubectl describe pod <pod-name> -n cloud-pipeline
   ```

2. **External IP stuck in <pending>**:
   - Wait 5-10 minutes
   - Check Azure LoadBalancer provisioning

3. **Image pull errors**:
   - Verify Docker Hub image exists
   - Check image name in deployment.yaml

### Azure Issues:

1. **AKS creation fails**:
   - Check Azure subscription limits
   - Verify region availability
   - Ensure proper permissions

2. **kubectl access denied**:
   ```bash
   az aks get-credentials --resource-group cloud-pipeline-rg --name cloud-pipeline-aks --overwrite-existing
   ```

## 📊 Grading Rubric

### Section 1: Docker & Local (10 marks)
- Local app running: 2 marks
- Dockerfile quality: 3 marks
- Container build/run: 3 marks
- Docker Hub push: 2 marks

### Section 2: Azure AKS (10 marks)
- AKS cluster creation: 3 marks
- App deployment: 4 marks
- Public IP exposure: 3 marks

### Section 3: GitHub (5 marks)
- Repository creation: 1 mark
- File management: 2 marks
- Git commands: 2 marks

**Total: 25 marks**

## 🎯 Success Criteria

Your deployment is successful when:
1. ✅ Application runs locally on localhost:3000
2. ✅ Docker container builds and runs successfully
3. ✅ Image is available on Docker Hub
4. ✅ AKS cluster is created and accessible
5. ✅ Application is deployed and running in AKS
6. ✅ Application is accessible via public IP
7. ✅ All code is committed to GitHub
8. ✅ Proper Git workflow is demonstrated

Good luck with your cloud deployment pipeline! 🚀