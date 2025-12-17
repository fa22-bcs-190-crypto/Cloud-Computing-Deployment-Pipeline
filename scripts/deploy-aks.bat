@echo off
echo ☁️ Deploying to Azure AKS...

echo 🔐 Logging into Azure CLI...
az login

echo 📋 Setting up AKS cluster...
set RESOURCE_GROUP=cloud-pipeline-rg
set CLUSTER_NAME=cloud-pipeline-aks
set LOCATION=eastus

echo 📦 Creating resource group: %RESOURCE_GROUP%
az group create --name %RESOURCE_GROUP% --location %LOCATION%

echo 🏗️ Creating AKS cluster: %CLUSTER_NAME%
az aks create --resource-group %RESOURCE_GROUP% --name %CLUSTER_NAME% --node-count 2 --enable-addons monitoring --generate-ssh-keys --tier free

echo 🔑 Getting AKS credentials...
az aks get-credentials --resource-group %RESOURCE_GROUP% --name %CLUSTER_NAME% --overwrite-existing

echo 🚀 Deploying to Kubernetes...
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/mongodb-deployment.yaml
kubectl apply -f k8s/app-deployment.yaml

echo ⏳ Waiting for deployments to be ready...
kubectl wait --for=condition=available --timeout=300s deployment/mongodb -n cloud-pipeline
kubectl wait --for=condition=available --timeout=300s deployment/cloud-pipeline-app -n cloud-pipeline

echo 🌍 Getting service information...
kubectl get services -n cloud-pipeline

echo 📋 Getting pod status...
kubectl get pods -n cloud-pipeline

echo ✅ Deployment completed!
echo 🔗 To get external IP: kubectl get service cloud-pipeline-service -n cloud-pipeline -w