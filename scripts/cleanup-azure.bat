@echo off
echo 🧹 Cleaning up Azure Resources...

echo ⚠️  WARNING: This will delete all Azure resources for this project!
echo Resource Group: cloud-pipeline-rg
echo AKS Cluster: cloud-pipeline-aks
echo.
set /p confirm="Are you sure you want to continue? (y/N): "

if /i "%confirm%" neq "y" (
    echo ❌ Cleanup cancelled.
    pause
    exit /b 0
)

echo 🗑️ Deleting Kubernetes resources...
kubectl delete namespace cloud-pipeline --ignore-not-found=true

echo 🗑️ Deleting AKS cluster...
az aks delete --resource-group cloud-pipeline-rg --name cloud-pipeline-aks --yes --no-wait

echo 🗑️ Deleting resource group...
az group delete --name cloud-pipeline-rg --yes --no-wait

echo ✅ Cleanup initiated!
echo 💡 Resources are being deleted in the background.
echo    You can check status in Azure Portal or run:
echo    az group show --name cloud-pipeline-rg