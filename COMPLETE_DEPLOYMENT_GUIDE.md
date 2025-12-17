# Complete DevOps Deployment Guide

## Project Overview
This is a complete 3-tier cloud deployment pipeline featuring:
- **Frontend**: HTML/CSS/JavaScript served by Nginx
- **Backend**: Node.js/Express API
- **Database**: MongoDB with initialization scripts

## Prerequisites
- Docker Desktop installed and running
- Azure CLI installed
- kubectl installed
- Python 3.8+ (for Selenium tests)
- Git repository setup
- Docker Hub account

## SECTION A: CONTAINERIZATION

### Step 1: Start Docker and Build Containers
```bash
# Run the automated script
scripts/start-docker.bat

# Or manually:
docker compose build --no-cache
docker compose up -d
```

### Step 2: Verify Containers
```bash
docker compose ps
docker compose logs -f
```

**Expected Output:**
- 3 containers running: frontend, backend, database
- Frontend accessible at http://localhost
- Backend API at http://localhost:3000
- MongoDB at localhost:27017

### Screenshots to Take:
1. `docker compose ps` showing all containers running
2. Application running in browser at http://localhost
3. API health check at http://localhost/health

## SECTION B: CI/CD AUTOMATION

### Step 1: Setup GitHub Repository
1. Create new GitHub repository
2. Push your code:
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/yourusername/your-repo.git
git push -u origin main
```

### Step 2: Configure GitHub Secrets
Go to GitHub repository → Settings → Secrets and variables → Actions

Add these secrets:
- `DOCKER_USERNAME`: Your Docker Hub username
- `DOCKER_PASSWORD`: Your Docker Hub password
- `AZURE_CREDENTIALS`: Azure service principal JSON
- `AZURE_RESOURCE_GROUP`: Your Azure resource group name
- `AKS_CLUSTER_NAME`: Your AKS cluster name

### Step 3: Create Azure Service Principal
```bash
az ad sp create-for-rbac --name "github-actions" --role contributor --scopes /subscriptions/YOUR_SUBSCRIPTION_ID --sdk-auth
```

### Step 4: Test Pipeline
1. Make a change to your code
2. Push to main branch
3. Check GitHub Actions tab for pipeline execution

**Screenshots to Take:**
1. GitHub Actions workflow running
2. All pipeline stages completed successfully
3. Docker images pushed to Docker Hub

## SECTION C: KUBERNETES ON AZURE (AKS)

### Step 1: Create AKS Cluster
```bash
# Update variables in the script first
scripts/create-aks-cluster.bat
```

### Step 2: Deploy Application
```bash
# Update Docker username in script
scripts/deploy-to-aks.bat
```

### Step 3: Verify Deployment
```bash
kubectl get pods -n cloudpipeline
kubectl get services -n cloudpipeline
kubectl get ingress -n cloudpipeline
```

### Step 4: Get External IP
```bash
kubectl get service cloudpipeline-frontend -n cloudpipeline
```

**Screenshots to Take:**
1. `kubectl get nodes` showing AKS cluster
2. `kubectl get pods -n cloudpipeline` showing all pods running
3. `kubectl get svc -n cloudpipeline` showing services
4. Application running on external IP

## SECTION D: CONFIGURATION MANAGEMENT USING ANSIBLE

### Step 1: Setup Target Servers
Create 2 Azure VMs or use existing servers:
- Web servers (for application)
- Database servers (for MongoDB)

### Step 2: Update Inventory
Edit `ansible/hosts.ini` with your server IPs:
```ini
[webservers]
web1 ansible_host=YOUR_WEB_SERVER_IP ansible_user=azureuser
web2 ansible_host=YOUR_WEB_SERVER_IP2 ansible_user=azureuser

[databases]
db1 ansible_host=YOUR_DB_SERVER_IP ansible_user=azureuser
```

### Step 3: Setup SSH Keys
```bash
ssh-keygen -t rsa -b 4096
ssh-copy-id azureuser@YOUR_SERVER_IP
```

### Step 4: Run Ansible Playbook
```bash
scripts/run-ansible.bat
```

**Screenshots to Take:**
1. Ansible playbook execution output
2. `ansible all -i ansible/hosts.ini -m ping` showing connectivity
3. Services running on configured servers

## SECTION E: SELENIUM AUTOMATED TESTING

### Step 1: Install Dependencies
```bash
pip install -r tests/requirements.txt
```

### Step 2: Start Application
```bash
docker compose up -d
```

### Step 3: Run Tests
```bash
scripts/run-selenium-tests.bat
```

**Screenshots to Take:**
1. All 5 test cases passing
2. Test execution summary
3. Browser automation in action (if not headless)

## Troubleshooting

### Docker Issues
- Ensure Docker Desktop is running
- Check port conflicts (3000, 27017, 80)
- Clear Docker cache: `docker system prune -a`

### AKS Issues
- Verify Azure CLI login: `az account show`
- Check kubectl context: `kubectl config current-context`
- Monitor pod logs: `kubectl logs -f deployment/cloudpipeline-backend -n cloudpipeline`

### Ansible Issues
- Test SSH connectivity: `ssh azureuser@SERVER_IP`
- Check Python version on target servers
- Verify sudo permissions

### Selenium Issues
- Install Chrome browser
- Check application is running on localhost
- Update Chrome driver if needed

## Final Submission Checklist

### Section A - Containerization (10 marks)
- [ ] frontend/Dockerfile
- [ ] backend/Dockerfile  
- [ ] database/Dockerfile
- [ ] docker-compose.yml
- [ ] Screenshot: All containers running
- [ ] Screenshot: Application accessible

### Section B - CI/CD Pipeline (14 marks)
- [ ] .github/workflows/ci-cd-pipeline.yml
- [ ] GitHub repository with code
- [ ] Screenshot: Pipeline execution
- [ ] Screenshot: All stages completed

### Section C - AKS Deployment (12 marks)
- [ ] k8s/ manifests updated
- [ ] AKS cluster created
- [ ] Application deployed
- [ ] Screenshot: kubectl get pods
- [ ] Screenshot: kubectl get svc
- [ ] Screenshot: Application running on external IP

### Section D - Ansible (8 marks)
- [ ] ansible/playbook.yml
- [ ] ansible/hosts.ini
- [ ] Screenshot: Playbook execution
- [ ] Screenshot: Services configured

### Section E - Selenium Testing (6 marks)
- [ ] tests/selenium_tests.py
- [ ] Screenshot: All tests passing
- [ ] Screenshot: Test execution report

## Architecture Diagram

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │    Backend      │    │   Database      │
│   (Nginx)       │    │  (Node.js)      │    │   (MongoDB)     │
│   Port: 80      │────│   Port: 3000    │────│   Port: 27017   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │  Load Balancer  │
                    │  (Azure AKS)    │
                    └─────────────────┘
                                 │
                    ┌─────────────────┐
                    │   Public IP     │
                    │  (Internet)     │
                    └─────────────────┘
```

## Contact Information
For issues or questions, please check:
1. Application logs: `docker compose logs -f`
2. Kubernetes logs: `kubectl logs -f deployment/cloudpipeline-backend -n cloudpipeline`
3. GitHub Actions logs in your repository