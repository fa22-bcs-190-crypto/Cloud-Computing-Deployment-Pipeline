@echo off
echo 🔍 Verifying Azure AKS Deployment...

echo 📋 Checking Azure CLI installation...
az --version
if %errorlevel% neq 0 (
    echo ❌ Azure CLI not found. Please install it first.
    echo 💡 Run: winget install Microsoft.AzureCLI
    pause
    exit /b 1
)

echo 🔑 Checking Azure login status...
az account show
if %errorlevel% neq 0 (
    echo ❌ Not logged into Azure. Please run: az login
    pause
    exit /b 1
)

echo 🏗️ Checking AKS cluster status...
az aks show --resource-group cloud-pipeline-rg --name cloud-pipeline-aks --query "provisioningState" -o tsv

echo 🔧 Checking kubectl configuration...
kubectl config current-context

echo 📦 Checking namespace...
kubectl get namespace cloud-pipeline

echo 🚀 Checking deployments...
kubectl get deployments -n cloud-pipeline

echo 📋 Checking pods...
kubectl get pods -n cloud-pipeline

echo 🌐 Checking services...
kubectl get services -n cloud-pipeline

echo 🔗 Getting external IP (this may take a few minutes)...
kubectl get service cloud-pipeline-service -n cloud-pipeline

echo ✅ Verification completed!
echo 💡 If EXTERNAL-IP shows <pending>, wait a few minutes and run:
echo    kubectl get service cloud-pipeline-service -n cloud-pipeline -w