# 🚀 Cloud Computing Deployment Pipeline

A complete full-stack application demonstrating the entire deployment pipeline from local development to cloud deployment using Docker, Azure AKS, and GitHub.

## 📋 Project Overview

This project demonstrates a complete cloud deployment pipeline with:
- **Frontend**: HTML/CSS/JavaScript Task Manager Interface
- **Backend**: Node.js/Express.js REST API
- **Database**: MongoDB Integration
- **Containerization**: Docker & Docker Compose
- **Cloud Deployment**: Azure Kubernetes Service (AKS)
- **Version Control**: GitHub Repository

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend       │    │   Database      │
│   HTML/CSS/JS   │◄──►│   Node.js       │◄──►│   MongoDB       │
│   Task Manager  │    │   Express API   │    │   Cloud/Local   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   Docker        │
                    │   Container     │
                    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │   Azure AKS     │
                    │   Kubernetes    │
                    └─────────────────┘
```

## 🔧 Section 1: Local Development & Docker (10 Marks)

### ✅ Run App Locally (2 marks)

1. **Install Dependencies**:
   ```bash
   npm install
   ```

2. **Start MongoDB** (using Docker):
   ```bash
   docker run -d --name mongodb -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=password123 mongo:7.0
   ```

3. **Start the Application**:
   ```bash
   npm start
   ```

4. **Access the App**:
   - Frontend: http://localhost:3000
   - API: http://localhost:3000/api/tasks
   - Health Check: http://localhost:3000/health

### 🐳 Create Dockerfile (3 marks)

The `Dockerfile` includes:
- Multi-stage build for optimization
- Security best practices (non-root user)
- Health checks
- Production-ready configuration

### 🧱 Build and Run Docker Container (3 marks)

1. **Build the Image**:
   ```bash
   docker build -t cloud-pipeline-app .
   ```

2. **Run with Docker Compose** (includes MongoDB):
   ```bash
   docker-compose up -d
   ```

3. **Test the Container**:
   ```bash
   curl http://localhost:3000/health
   ```

### ☁️ Push to Docker Hub (2 marks)

1. **Login to Docker Hub**:
   ```bash
   docker login
   ```

2. **Tag the Image**:
   ```bash
   docker tag cloud-pipeline-app your-dockerhub-username/cloud-pipeline-app:latest
   ```

3. **Push to Docker Hub**:
   ```bash
   docker push your-dockerhub-username/cloud-pipeline-app:latest
   ```

## ☁️ Section 2: Azure Kubernetes Deployment (10 Marks)

### 🏗️ Create Azure Kubernetes Cluster (3 marks)

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
   az aks create --resource-group cloud-pipeline-rg --name cloud-pipeline-aks --node-count 2 --enable-addons monitoring --generate-ssh-keys
   ```

4. **Get Credentials**:
   ```bash
   az aks get-credentials --resource-group cloud-pipeline-rg --name cloud-pipeline-aks
   ```

### 🚀 Deploy Containerized App (4 marks)

1. **Update Image Reference** in `k8s/app-deployment.yaml`:
   ```yaml
   image: your-dockerhub-username/cloud-pipeline-app:latest
   ```

2. **Deploy to Kubernetes**:
   ```bash
   kubectl apply -f k8s/namespace.yaml
   kubectl apply -f k8s/mongodb-deployment.yaml
   kubectl apply -f k8s/app-deployment.yaml
   ```

3. **Check Deployment Status**:
   ```bash
   kubectl get pods -n cloud-pipeline
   kubectl get services -n cloud-pipeline
   ```

### 🌍 Expose via Public IP (3 marks)

1. **Get External IP**:
   ```bash
   kubectl get service cloud-pipeline-service -n cloud-pipeline
   ```

2. **Access the Application**:
   - Use the EXTERNAL-IP from the service
   - Example: http://[EXTERNAL-IP]/

3. **Optional: Setup Ingress** (for custom domain):
   ```bash
   kubectl apply -f k8s/ingress.yaml
   ```

## 💻 Section 3: GitHub Repository (5 Marks)

### 📁 Create GitHub Repository (1 mark)

1. Create a new repository on GitHub
2. Clone or initialize locally:
   ```bash
   git init
   git remote add origin https://github.com/your-username/cloud-deployment-pipeline.git
   ```

### 📄 Add All Files (2 marks)

```bash
git add .
git commit -m "Initial commit: Complete cloud deployment pipeline"
```

### ⬆️ Git Commands Usage (2 marks)

```bash
# Add files
git add .

# Commit changes
git commit -m "Add deployment pipeline with Docker and Kubernetes"

# Push to GitHub
git push -u origin main

# Pull latest changes
git pull origin main

# Check status
git status

# View commit history
git log --oneline
```

## 📁 Project Structure

```
cloud-deployment-pipeline/
├── public/                 # Frontend files
│   ├── index.html         # Main HTML interface
│   ├── styles.css         # CSS styling
│   └── script.js          # JavaScript functionality
├── k8s/                   # Kubernetes manifests
│   ├── namespace.yaml     # Namespace definition
│   ├── mongodb-deployment.yaml  # MongoDB deployment
│   ├── app-deployment.yaml      # App deployment
│   └── ingress.yaml       # Ingress configuration
├── scripts/               # Deployment scripts
│   ├── deploy-local.bat   # Local deployment
│   ├── docker-build.bat   # Docker build script
│   ├── docker-push.bat    # Docker Hub push
│   └── deploy-aks.bat     # AKS deployment
├── server.js              # Node.js backend server
├── package.json           # Node.js dependencies
├── Dockerfile             # Docker configuration
├── docker-compose.yml     # Local Docker setup
├── .dockerignore          # Docker ignore rules
├── .env.example           # Environment variables template
└── README.md              # This documentation
```

## 🔗 Required Links for Submission

After completing the deployment, you'll have:

1. **GitHub Repository**: `https://github.com/your-username/cloud-deployment-pipeline`
2. **Docker Hub Image**: `https://hub.docker.com/r/your-dockerhub-username/cloud-pipeline-app`
3. **Azure App URL**: `http://[AKS-EXTERNAL-IP]/` (from kubectl get services)

## 🖼️ Screenshots to Include

1. **Local Application Running** (browser showing localhost:3000)
2. **Docker Build Success** (terminal showing successful build)
3. **Docker Hub Repository** (showing pushed image)
4. **AKS Cluster Creation** (Azure portal or CLI output)
5. **Kubernetes Deployment** (kubectl get pods output)
6. **Public Application Access** (browser showing public IP)
7. **GitHub Repository** (showing all committed files)

## 🛠️ Troubleshooting

### Common Issues:

1. **MongoDB Connection Failed**:
   - Ensure MongoDB is running: `docker ps`
   - Check connection string in environment variables

2. **Docker Build Fails**:
   - Check Dockerfile syntax
   - Ensure all files are present: `ls -la`

3. **AKS Deployment Issues**:
   - Verify Azure CLI login: `az account show`
   - Check kubectl context: `kubectl config current-context`

4. **External IP Pending**:
   - Wait a few minutes for Azure to provision the LoadBalancer
   - Check service status: `kubectl describe service cloud-pipeline-service -n cloud-pipeline`

## 📚 Technologies Used

- **Frontend**: HTML5, CSS3, JavaScript (ES6+)
- **Backend**: Node.js, Express.js
- **Database**: MongoDB
- **Containerization**: Docker, Docker Compose
- **Orchestration**: Kubernetes
- **Cloud Platform**: Microsoft Azure (AKS)
- **Version Control**: Git, GitHub
- **CI/CD**: Docker Hub

## 🎯 Learning Outcomes

This project demonstrates:
- Full-stack web development
- Containerization best practices
- Kubernetes orchestration
- Cloud deployment strategies
- DevOps pipeline implementation
- Version control workflows

---

**Note**: Replace `your-dockerhub-username` and `your-username` with your actual usernames throughout the project files before deployment.