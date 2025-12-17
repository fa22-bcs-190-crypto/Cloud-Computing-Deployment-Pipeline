@echo off
echo ========================================
echo   AZURE SERVICE PRINCIPAL SETUP
echo ========================================

REM Check if Azure CLI is installed
az --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Azure CLI is not installed. Please install it first.
    echo Download from: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
    pause
    exit /b 1
)

echo Logging into Azure...
az login

if %errorlevel% neq 0 (
    echo Failed to login to Azure
    pause
    exit /b 1
)

echo Getting subscription information...
az account show

echo.
set /p SUBSCRIPTION_ID="Enter your Azure Subscription ID: "

if "%SUBSCRIPTION_ID%"=="" (
    echo Subscription ID cannot be empty
    pause
    exit /b 1
)

echo.
echo Creating service principal for GitHub Actions...
echo This will create a service principal with Contributor role

az ad sp create-for-rbac --name "github-actions-cloudpipeline" --role contributor --scopes /subscriptions/%SUBSCRIPTION_ID% --sdk-auth

if %errorlevel% neq 0 (
    echo Failed to create service principal
    pause
    exit /b 1
)

echo.
echo ========================================
echo   SERVICE PRINCIPAL CREATED!
echo ========================================
echo.
echo IMPORTANT: Copy the JSON output above and save it as AZURE_CREDENTIALS secret in GitHub
echo.
echo The JSON should look like:
echo {
echo   "clientId": "...",
echo   "clientSecret": "...",
echo   "subscriptionId": "...",
echo   "tenantId": "...",
echo   "activeDirectoryEndpointUrl": "...",
echo   "resourceManagerEndpointUrl": "...",
echo   "activeDirectoryGraphResourceId": "...",
echo   "sqlManagementEndpointUrl": "...",
echo   "galleryEndpointUrl": "...",
echo   "managementEndpointUrl": "..."
echo }
echo.
echo Next steps:
echo 1. Copy the entire JSON output
echo 2. Go to your GitHub repository
echo 3. Settings → Secrets and variables → Actions
echo 4. Click "New repository secret"
echo 5. Name: AZURE_CREDENTIALS
echo 6. Value: Paste the JSON
echo ========================================

pause