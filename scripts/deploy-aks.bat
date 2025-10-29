@echo off
echo ☁️ Deploying to Azure AKS...

echo 🔐 Please ensure you're logged into Azure CLI:
az login

echo 📋 Setting up AKS cluster (if not exists)...
set RESOURCE_GROUP=cloud-pipeline-rg
set CLUSTER_NAME=cloud-pipeline-aks
set LOCATION=eastus

echo Creating resource group...
az group create --name %RESOURCE_GROUP% --location %LOCATION%

echo Creating AKS cluster...
az aks create --resource-group %RESOURCE_GROUP% --name %CLUSTER_NAME% --node-count 2 --enable-addons monitoring --generate-ssh-keys

echo Getting AKS credentials...
az aks get-credentials --resource-group %RESOURCE_GROUP% --name %CLUSTER_NAME%

echo 🚀 Deploying to Kubernetes...
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/mongodb-deployment.yaml
kubectl apply -f k8s/app-deployment.yaml

echo ⏳ Waiting for deployment...
kubectl wait --for=condition=available --timeout=300s deployment/cloud-pipeline-app -n cloud-pipeline

echo 🌍 Getting external IP...
kubectl get service cloud-pipeline-service -n cloud-pipeline

echo ✅ Deployment completed!
echo 📋 Check status: kubectl get pods -n cloud-pipeline