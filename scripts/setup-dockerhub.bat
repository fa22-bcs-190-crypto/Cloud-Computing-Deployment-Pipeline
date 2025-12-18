@echo off
echo ========================================
echo   DOCKER HUB SETUP FOR khaan11
echo ========================================

echo Logging into Docker Hub...
echo Please enter your Docker Hub credentials when prompted.
echo.

docker login

if %errorlevel% neq 0 (
    echo ❌ Docker Hub login failed
    echo Please check your credentials and try again
    pause
    exit /b 1
)

echo ✅ Docker Hub login successful!
echo.

echo Building and pushing images to Docker Hub...
echo This will create 3 repositories:
echo - khaan11/cloudpipeline-frontend
echo - khaan11/cloudpipeline-backend  
echo - khaan11/cloudpipeline-database
echo.

echo Building frontend image...
docker build -t khaan11/cloudpipeline-frontend:latest -f frontend/Dockerfile .
if %errorlevel% neq 0 (
    echo ❌ Frontend build failed
    pause
    exit /b 1
)

echo Building backend image...
docker build -t khaan11/cloudpipeline-backend:latest -f backend/Dockerfile .
if %errorlevel% neq 0 (
    echo ❌ Backend build failed
    pause
    exit /b 1
)

echo Building database image...
docker build -t khaan11/cloudpipeline-database:latest -f database/Dockerfile .
if %errorlevel% neq 0 (
    echo ❌ Database build failed
    pause
    exit /b 1
)

echo Pushing frontend image...
docker push khaan11/cloudpipeline-frontend:latest
if %errorlevel% neq 0 (
    echo ❌ Frontend push failed
    pause
    exit /b 1
)

echo Pushing backend image...
docker push khaan11/cloudpipeline-backend:latest
if %errorlevel% neq 0 (
    echo ❌ Backend push failed
    pause
    exit /b 1
)

echo Pushing database image...
docker push khaan11/cloudpipeline-database:latest
if %errorlevel% neq 0 (
    echo ❌ Database push failed
    pause
    exit /b 1
)

echo.
echo ========================================
echo   🎉 DOCKER HUB SETUP COMPLETE!
echo ========================================
echo.
echo Successfully created repositories:
echo ✅ https://hub.docker.com/r/khaan11/cloudpipeline-frontend
echo ✅ https://hub.docker.com/r/khaan11/cloudpipeline-backend
echo ✅ https://hub.docker.com/r/khaan11/cloudpipeline-database
echo.
echo Next steps:
echo 1. Go to hub.docker.com
echo 2. Account Settings → Security
echo 3. Create New Access Token
echo 4. Copy the token for GitHub secrets
echo ========================================

pause