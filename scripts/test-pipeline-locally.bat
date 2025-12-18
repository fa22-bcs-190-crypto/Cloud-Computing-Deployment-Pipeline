@echo off
echo ========================================
echo   TESTING CI/CD PIPELINE LOCALLY
echo ========================================

echo Step 1: Testing Build Stage...
echo --------------------------------
npm run build
if %errorlevel% neq 0 (
    echo ❌ Build stage failed
    pause
    exit /b 1
)
echo ✅ Build stage passed

echo.
echo Step 2: Testing Unit Tests...
echo --------------------------------
node tests/unit-tests.js
if %errorlevel% neq 0 (
    echo ❌ Unit tests failed
    pause
    exit /b 1
)
echo ✅ Unit tests passed

echo.
echo Step 3: Testing Integration Tests...
echo --------------------------------
node tests/integration-tests.js
if %errorlevel% neq 0 (
    echo ❌ Integration tests failed
    pause
    exit /b 1
)
echo ✅ Integration tests passed

echo.
echo Step 4: Testing Docker Build...
echo --------------------------------
docker compose build --no-cache
if %errorlevel% neq 0 (
    echo ❌ Docker build failed
    pause
    exit /b 1
)
echo ✅ Docker build passed

echo.
echo ========================================
echo   🎉 ALL PIPELINE TESTS PASSED!
echo ========================================
echo.
echo Your CI/CD pipeline is ready for GitHub!
echo.
echo Next steps:
echo 1. Create GitHub repository
echo 2. Push your code: git push origin main
echo 3. Add Docker Hub secrets to GitHub
echo 4. Watch the pipeline run automatically
echo.
echo Pipeline includes:
echo ✅ Build Stage (Frontend + Backend)
echo ✅ Automated Tests (Unit + Integration)
echo ✅ Docker Image Build and Push
echo ✅ Kubernetes Deployment
echo ✅ Trigger on Push/PR
echo ========================================

pause