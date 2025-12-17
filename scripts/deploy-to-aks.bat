@echo off
echo ========================================
echo   DEPLOYING TO AZURE AKS
echo ========================================

REM Set variables - UPDATE THESE WITH YOUR VALUES
set DOCKER_USERNAME=your-docker-username
set IMAGE_TAG=latest

echo Checking kubectl connection...
kubectl get nodes
if %errorlevel% neq 0 (
    echo Error: Not connected to AKS cluster
    echo Run create-aks-cluster.bat first
    pause
    exit /b 1
)

echo Building and pushing Docker images...
docker build -t %DOCKER_USERNAME%/cloudpipeline-frontend:%IMAGE_TAG% -f frontend/Dockerfile .
docker build -t %DOCKER_USERNAME%/cloudpipeline-backend:%IMAGE_TAG% -f backend/Dockerfile .
docker build -t %DOCKER_USERNAME%/cloudpipeline-database:%IMAGE_TAG% -f database/Dockerfile .

docker push %DOCKER_USERNAME%/cloudpipeline-frontend:%IMAGE_TAG%
docker push %DOCKER_USERNAME%/cloudpipeline-backend:%IMAGE_TAG%
docker push %DOCKER_USERNAME%/cloudpipeline-database:%IMAGE_TAG%

echo Updating Kubernetes manifests with image tags...
powershell -Command "(Get-Content k8s/app-deployment.yaml) -replace 'IMAGE_TAG_FRONTEND', '%DOCKER_USERNAME%/cloudpipeline-frontend:%IMAGE_TAG%' | Set-Content k8s/app-deployment-temp.yaml"
powershell -Command "(Get-Content k8s/app-deployment-temp.yaml) -replace 'IMAGE_TAG_BACKEND', '%DOCKER_USERNAME%/cloudpipeline-backend:%IMAGE_TAG%' | Set-Content k8s/app-deployment-final.yaml"
powershell -Command "(Get-Content k8s/mongodb-deployment.yaml) -replace 'IMAGE_TAG_DATABASE', '%DOCKER_USERNAME%/cloudpipeline-database:%IMAGE_TAG%' | Set-Content k8s/mongodb-deployment-final.yaml"

echo Deploying to Kubernetes...
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/mongodb-deployment-final.yaml
kubectl apply -f k8s/app-deployment-final.yaml
kubectl apply -f k8s/ingress.yaml

echo Waiting for deployments to be ready...
kubectl wait --for=condition=available --timeout=300s deployment/mongodb -n cloudpipeline
kubectl wait --for=condition=available --timeout=300s deployment/cloudpipeline-backend -n cloudpipeline
kubectl wait --for=condition=available --timeout=300s deployment/cloudpipeline-frontend -n cloudpipeline

echo Getting deployment status...
kubectl get pods -n cloudpipeline
kubectl get services -n cloudpipeline
kubectl get ingress -n cloudpipeline

echo Getting external IP...
kubectl get service cloudpipeline-frontend -n cloudpipeline

echo Cleaning up temporary files...
del k8s\app-deployment-temp.yaml
del k8s\app-deployment-final.yaml
del k8s\mongodb-deployment-final.yaml

echo.
echo ========================================
echo   DEPLOYMENT COMPLETED!
echo ========================================
echo Check the external IP above and access your application
echo Use 'kubectl get pods -n cloudpipeline' to monitor pods
echo Use 'kubectl logs -f deployment/cloudpipeline-backend -n cloudpipeline' for logs
echo ========================================

pause