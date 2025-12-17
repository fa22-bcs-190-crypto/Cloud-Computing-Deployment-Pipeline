@echo off
echo ========================================
echo   GITHUB REPOSITORY SETUP
echo ========================================

REM Check if git is installed
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Git is not installed. Please install Git first.
    pause
    exit /b 1
)

echo Current directory: %cd%
echo.

REM Initialize git repository if not already done
if not exist ".git" (
    echo Initializing Git repository...
    git init
    echo ✅ Git repository initialized
) else (
    echo ✅ Git repository already exists
)

REM Create .gitignore if it doesn't exist
if not exist ".gitignore" (
    echo Creating .gitignore file...
    echo node_modules/ > .gitignore
    echo .env >> .gitignore
    echo *.log >> .gitignore
    echo .DS_Store >> .gitignore
    echo Thumbs.db >> .gitignore
    echo ✅ .gitignore created
)

REM Add all files
echo Adding files to git...
git add .

REM Check if there are changes to commit
git diff --staged --quiet
if %errorlevel% neq 0 (
    echo Committing changes...
    git commit -m "Initial commit: Complete DevOps pipeline with Docker, K8s, and CI/CD"
    echo ✅ Changes committed
) else (
    echo ✅ No changes to commit
)

echo.
echo ========================================
echo   NEXT STEPS:
echo ========================================
echo 1. Create a new repository on GitHub
echo 2. Copy the repository URL
echo 3. Run these commands:
echo.
echo    git remote add origin https://github.com/yourusername/your-repo.git
echo    git branch -M main
echo    git push -u origin main
echo.
echo 4. Go to GitHub repository settings
echo 5. Add these secrets in Settings → Secrets and variables → Actions:
echo.
echo    DOCKER_USERNAME: your-docker-hub-username
echo    DOCKER_PASSWORD: your-docker-hub-password
echo    AZURE_CREDENTIALS: your-azure-service-principal-json
echo    AZURE_RESOURCE_GROUP: your-resource-group-name
echo    AKS_CLUSTER_NAME: your-aks-cluster-name
echo.
echo 6. Push code to trigger the CI/CD pipeline
echo ========================================

pause