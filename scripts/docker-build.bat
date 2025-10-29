@echo off
echo 🐳 Building Docker Image...

set IMAGE_NAME=hafsa44969/cloud-pipeline-app
set TAG=latest

echo Building image: %IMAGE_NAME%:%TAG%
docker build -t %IMAGE_NAME%:%TAG% .

echo ✅ Docker image built successfully!
echo 📋 Image: %IMAGE_NAME%:%TAG%

echo 🧪 Testing the container...
docker run -d --name test-container -p 3001:3000 %IMAGE_NAME%:%TAG%

echo ⏳ Waiting for container to start...
timeout /t 5

echo 🔍 Container health check...
curl http://localhost:3001/health

echo 🛑 Stopping test container...
docker stop test-container
docker rm test-container

echo ✅ Container test completed!