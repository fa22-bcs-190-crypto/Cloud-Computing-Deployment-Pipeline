# Azure AKS Deployment Commands

## Step 1: Login to Azure
```bash
az login
```

## Step 2: Create Resource Group
```bash
az group create --name cloud-pipeline-rg --location eastus
```

## Step 3: Create AKS Cluster
```bash
az aks create --resource-group cloud-pipeline-rg --name cloud-pipeline-aks --node-count 2 --enable-addons monitoring --generate-ssh-keys --tier free
```

## Step 4: Get AKS Credentials
```bash
az aks get-credentials --resource-group cloud-pipeline-rg --name cloud-pipeline-aks --overwrite-existing
```

## Step 5: Deploy to Kubernetes
```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/mongodb-deployment.yaml
kubectl apply -f k8s/app-deployment.yaml
```

## Step 6: Check Deployment Status
```bash
kubectl get pods -n cloud-pipeline
kubectl get services -n cloud-pipeline
```

## Step 7: Get External IP
```bash
kubectl get service cloud-pipeline-service -n cloud-pipeline -w
```

## Step 8: Access Your Application
Once you get the EXTERNAL-IP, access your app at:
```
http://[EXTERNAL-IP]/
```

## Troubleshooting Commands
```bash
# Check pod logs
kubectl logs -f deployment/cloud-pipeline-app -n cloud-pipeline

# Check MongoDB logs
kubectl logs -f deployment/mongodb -n cloud-pipeline

# Describe services
kubectl describe service cloud-pipeline-service -n cloud-pipeline

# Check all resources
kubectl get all -n cloud-pipeline
```