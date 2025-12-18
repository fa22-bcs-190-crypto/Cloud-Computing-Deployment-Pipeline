@echo off
echo ========================================
echo   PUSHING TO GITHUB REPOSITORY
echo ========================================

echo Current repository: https://github.com/fa22-bcs-190-crypto/Cloud-Computing-Deployment-Pipeline.git
echo.

echo Adding all files...
git add .

echo Committing changes...
git commit -m "Complete CI/CD pipeline with Docker Hub integration and automated tests"

if %errorlevel% neq 0 (
    echo No changes to commit or commit failed
)

echo Pushing to GitHub...
git push origin master

if %errorlevel% neq 0 (
    echo ❌ Push failed. Trying to push to main branch...
    git push origin main
    if %errorlevel% neq 0 (
        echo ❌ Push to main also failed
        echo Please check your repository settings
        pause
        exit /b 1
    )
)

echo ✅ Successfully pushed to GitHub!
echo.

echo ========================================
echo   NEXT STEPS FOR CI/CD PIPELINE
echo ========================================
echo.
echo 1. Go to your GitHub repository:
echo    https://github.com/fa22-bcs-190-crypto/Cloud-Computing-Deployment-Pipeline
echo.
echo 2. Go to Settings → Secrets and variables → Actions
echo.
echo 3. Add these secrets:
echo    - DOCKER_USERNAME: khaan11
echo    - DOCKER_PASSWORD: [your-docker-hub-access-token]
echo.
echo 4. The pipeline will run automatically on your next push!
echo.
echo Pipeline includes:
echo ✅ Build Stage (Frontend + Backend)
echo ✅ Automated Tests (Unit + Integration)  
echo ✅ Docker Image Build and Push to khaan11/*
echo ✅ Kubernetes Deployment (when Azure secrets added)
echo ========================================

pause