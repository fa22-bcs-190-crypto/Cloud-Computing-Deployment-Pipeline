@echo off
echo Starting Docker Desktop...
start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"

echo Waiting for Docker to start...
timeout /t 30 /nobreak

echo Checking Docker status...
docker --version
if %errorlevel% neq 0 (
    echo Docker is not running. Please start Docker Desktop manually.
    pause
    exit /b 1
)

echo Docker is ready!
echo Building containers...
docker compose build --no-cache

echo Starting all services...
docker compose up -d

echo Checking container status...
docker compose ps

echo.
echo ========================================
echo   CONTAINERIZATION COMPLETE!
echo ========================================
echo Frontend: http://localhost
echo Backend API: http://localhost:3000
echo MongoDB: localhost:27017
echo.
echo To view logs: docker compose logs -f
echo To stop: docker compose down
echo ========================================

pause