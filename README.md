# 🚀 Cloud Computing Deployment Pipeline

## Overview
Complete DevOps pipeline demonstrating containerization, CI/CD automation, and cloud deployment.

## Architecture
- **Frontend**: HTML/CSS/JavaScript served by Nginx
- **Backend**: Node.js/Express API
- **Database**: MongoDB with initialization scripts

## CI/CD Pipeline
- ✅ **Build Stage**: Frontend + Backend compilation
- ✅ **Test Stage**: Automated unit and integration tests
- ✅ **Docker Stage**: Multi-container image builds
- ✅ **Deploy Stage**: Kubernetes deployment ready

## Docker Images
- `khaan11/cloudpipeline-frontend:latest`
- `khaan11/cloudpipeline-backend:latest`
- `khaan11/cloudpipeline-database:latest`

## Local Development
```bash
# Start all services
docker compose up -d

# Access application
http://localhost
```

## Pipeline Status
![CI/CD Pipeline](https://github.com/fa22-bcs-190-crypto/Cloud-Computing-Deployment-Pipeline/actions/workflows/simple-ci-cd.yml/badge.svg)

## Assignment Sections
- [x] **Section A**: Containerization (Docker + Docker Compose)
- [x] **Section B**: CI/CD Automation (GitHub Actions)
- [ ] **Section C**: Kubernetes on Azure (AKS)
- [ ] **Section D**: Configuration Management (Ansible)
- [ ] **Section E**: Selenium Testing

---
**Author**: Muhammad Khan (fa22-bcs-190-crypto)  
**Course**: Cloud Computing & DevOps