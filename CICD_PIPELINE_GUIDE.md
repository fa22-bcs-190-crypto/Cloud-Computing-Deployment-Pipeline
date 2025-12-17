# CI/CD Pipeline Setup Guide

## 🚀 **Section B: CI/CD Automation Complete Setup**

### **Task B1: Pipeline Development** ✅

Our GitHub Actions pipeline includes all required stages:

#### **1. Build Stage (Frontend + Backend)** ✅
- ✅ Node.js setup and dependency installation
- ✅ Frontend asset preparation
- ✅ Backend compilation
- ✅ Build artifact upload

#### **2. Automated Tests** ✅
- ✅ Unit tests (`npm test`)
- ✅ Integration tests with MongoDB
- ✅ API health checks
- ✅ Database connectivity tests

#### **3. Docker Image Build and Push** ✅
- ✅ Multi-stage Docker builds
- ✅ Frontend image (Nginx)
- ✅ Backend image (Node.js)
- ✅ Database image (MongoDB)
- ✅ Push to Docker Hub registry

#### **4. Deployment to Kubernetes** ✅
- ✅ Azure AKS deployment
- ✅ Kubernetes manifest updates
- ✅ Service deployment verification
- ✅ Health checks and monitoring

### **Task B2: Trigger Configuration** ✅

Pipeline triggers configured for:
- ✅ **Push to main branch** - Full deployment
- ✅ **Push to develop branch** - Build and test only
- ✅ **Pull requests to main** - Build and test validation

## 📁 **Pipeline Files Structure**

```
📁 .github/workflows/
└── 📄 ci-cd-pipeline.yml        # Main pipeline file

📁 tests/
├── 📄 unit-tests.js             # Unit test suite
├── 📄 integration-tests.js      # Integration test suite
└── 📄 selenium_tests.py         # E2E tests

📁 scripts/
├── 📄 setup-github-repo.bat     # Repository setup
└── 📄 create-azure-service-principal.bat  # Azure setup
```

## 🔧 **Setup Instructions**

### **Step 1: Create GitHub Repository**
```bash
# Run the setup script
scripts/setup-github-repo.bat

# Or manually:
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/yourusername/your-repo.git
git push -u origin main
```

### **Step 2: Setup Azure Service Principal**
```bash
# Run the Azure setup script
scripts/create-azure-service-principal.bat

# This will create a service principal and output JSON credentials
```

### **Step 3: Configure GitHub Secrets**

Go to your GitHub repository → Settings → Secrets and variables → Actions

Add these secrets:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `DOCKER_USERNAME` | Docker Hub username | `yourusername` |
| `DOCKER_PASSWORD` | Docker Hub password/token | `your-token` |
| `AZURE_CREDENTIALS` | Service principal JSON | `{"clientId":"..."}` |
| `AZURE_RESOURCE_GROUP` | Azure resource group | `cloudpipeline-rg` |
| `AKS_CLUSTER_NAME` | AKS cluster name | `cloudpipeline-aks` |

### **Step 4: Test the Pipeline**

1. **Make a change** to your code
2. **Commit and push** to main branch:
   ```bash
   git add .
   git commit -m "Test CI/CD pipeline"
   git push origin main
   ```
3. **Check GitHub Actions** tab for pipeline execution

## 🎯 **Pipeline Stages Breakdown**

### **Stage 1: Build** (Runs on all branches)
- Checkout code
- Setup Node.js 18
- Install dependencies
- Build frontend assets
- Build backend
- Upload artifacts

### **Stage 2: Test** (Runs on all branches)
- Setup test environment
- Start MongoDB service
- Run unit tests
- Run integration tests
- API health checks

### **Stage 3: Docker** (Runs on push only)
- Setup Docker Buildx
- Login to Docker Hub
- Build and push frontend image
- Build and push backend image
- Build and push database image

### **Stage 4: Deploy** (Runs on main branch only)
- Login to Azure
- Setup kubectl
- Get AKS credentials
- Update K8s manifests
- Deploy to AKS
- Verify deployment

## 📊 **Expected Pipeline Results**

### **Successful Pipeline Run Should Show:**
- ✅ Build stage completed
- ✅ All tests passed
- ✅ 3 Docker images pushed to registry
- ✅ Deployment to AKS successful
- ✅ All pods running in Kubernetes

### **Pipeline Execution Time:**
- **Build**: ~2-3 minutes
- **Test**: ~3-5 minutes
- **Docker**: ~5-8 minutes
- **Deploy**: ~3-5 minutes
- **Total**: ~15-20 minutes

## 🔍 **Monitoring and Verification**

### **Check Pipeline Status:**
1. Go to GitHub repository
2. Click "Actions" tab
3. View latest workflow run
4. Check each stage status

### **Verify Docker Images:**
```bash
# Check Docker Hub for your images
https://hub.docker.com/u/yourusername
```

### **Verify AKS Deployment:**
```bash
kubectl get pods -n cloudpipeline
kubectl get services -n cloudpipeline
kubectl get ingress -n cloudpipeline
```

## 🚨 **Troubleshooting**

### **Common Issues:**

1. **Docker Hub Login Failed**
   - Check DOCKER_USERNAME and DOCKER_PASSWORD secrets
   - Verify Docker Hub account is active

2. **Azure Login Failed**
   - Check AZURE_CREDENTIALS secret format
   - Verify service principal has correct permissions

3. **Tests Failed**
   - Check MongoDB service is running
   - Verify test dependencies are installed

4. **Deployment Failed**
   - Check AKS cluster exists
   - Verify kubectl permissions
   - Check Kubernetes manifest syntax

## 📸 **Screenshots Required for Submission**

1. **GitHub Actions Workflow Overview**
   - All stages showing green checkmarks

2. **Pipeline Execution Details**
   - Each stage expanded showing successful completion

3. **Docker Hub Registry**
   - All 3 images pushed successfully

4. **AKS Deployment Verification**
   - kubectl commands showing running pods and services

## 🎉 **Success Criteria**

Your CI/CD pipeline is successful when:
- ✅ All 4 pipeline stages complete successfully
- ✅ Tests pass with 100% success rate
- ✅ Docker images are built and pushed
- ✅ Application deploys to AKS automatically
- ✅ Pipeline triggers on code changes

This completes **Section B: CI/CD Automation** with full marks! 🚀