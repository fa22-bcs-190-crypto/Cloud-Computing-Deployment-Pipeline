@echo off
echo ========================================
echo   CREATING AZURE AKS CLUSTER
echo ========================================

REM Set variables - UPDATE THESE WITH YOUR VALUES
set RESOURCE_GROUP=cloudpipeline-rg
set CLUSTER_NAME=cloudpipeline-aks
set LOCATION=eastus
set NODE_COUNT=3
set NODE_SIZE=Standard_B2s

echo Logging into Azure...
az login

echo Creating resource group...
az group create --name %RESOURCE_GROUP% --location %LOCATION%

echo Creating AKS cluster (this may take 10-15 minutes)...
az aks create ^
    --resource-group %RESOURCE_GROUP% ^
    --name %CLUSTER_NAME% ^
    --node-count %NODE_COUNT% ^
    --node-vm-size %NODE_SIZE% ^
    --enable-addons monitoring ^
    --generate-ssh-keys ^
    --enable-managed-identity

echo Getting AKS credentials...
az aks get-credentials --resource-group %RESOURCE_GROUP% --name %CLUSTER_NAME%

echo Verifying cluster connection...
kubectl get nodes

echo Installing NGINX Ingress Controller...
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml

echo Waiting for ingress controller to be ready...
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=120s

echo.
echo ========================================
echo   AKS CLUSTER CREATED SUCCESSFULLY!
echo ========================================
echo Resource Group: %RESOURCE_GROUP%
echo Cluster Name: %CLUSTER_NAME%
echo Location: %LOCATION%
echo.
echo Next steps:
echo 1. Run deploy-to-aks.bat to deploy your application
echo 2. Use 'kubectl get nodes' to verify cluster
echo ========================================

pause