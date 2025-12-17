@echo off
echo ========================================
echo   SELENIUM AUTOMATED TESTING
echo ========================================

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python is not installed. Please install Python 3.8+ first.
    pause
    exit /b 1
)

REM Check if pip is available
pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo pip is not available. Please install pip first.
    pause
    exit /b 1
)

echo Installing test dependencies...
pip install -r tests/requirements.txt

REM Check if Chrome is installed
where chrome >nul 2>&1
if %errorlevel% neq 0 (
    echo Google Chrome is not installed or not in PATH.
    echo Please install Google Chrome to run Selenium tests.
    pause
    exit /b 1
)

echo Checking if application is running...
curl -f http://localhost/health >nul 2>&1
if %errorlevel% neq 0 (
    echo Warning: Application doesn't seem to be running on localhost
    echo Please start your application first with docker-compose up
    set /p continue="Continue with tests anyway? (y/n): "
    if /i not "%continue%"=="y" exit /b 1
)

echo.
echo Starting Selenium tests...
echo ========================================

python tests/selenium_tests.py

echo.
echo ========================================
echo   SELENIUM TESTING COMPLETED!
echo ========================================
echo Check the output above for test results
echo Screenshots and logs are available in the tests directory
echo ========================================

pause