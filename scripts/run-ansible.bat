@echo off
echo ========================================
echo   RUNNING ANSIBLE PLAYBOOK
echo ========================================

REM Check if Ansible is installed
ansible --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Ansible is not installed. Installing via pip...
    pip install ansible
    if %errorlevel% neq 0 (
        echo Failed to install Ansible. Please install Python and pip first.
        pause
        exit /b 1
    )
)

echo Checking inventory file...
if not exist "ansible\hosts.ini" (
    echo Error: ansible\hosts.ini not found
    echo Please update the hosts.ini file with your server IPs
    pause
    exit /b 1
)

echo Testing connectivity to hosts...
ansible all -i ansible/hosts.ini -m ping

if %errorlevel% neq 0 (
    echo Warning: Some hosts are not reachable
    echo Please check your SSH keys and host connectivity
    set /p continue="Continue anyway? (y/n): "
    if /i not "%continue%"=="y" exit /b 1
)

echo Running Ansible playbook...
ansible-playbook -i ansible/hosts.ini ansible/playbook.yml -v

echo.
echo ========================================
echo   ANSIBLE PLAYBOOK COMPLETED!
echo ========================================
echo Check the output above for any errors
echo All servers should now have the required software installed
echo ========================================

pause