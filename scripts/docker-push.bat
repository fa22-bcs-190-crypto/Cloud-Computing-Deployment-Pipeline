@echo off
echo 📤 Pushing to Docker Hub...

set IMAGE_NAME=hafsa44969/cloud-pipeline-app
set TAG=latest

echo 🔐 Please login to Docker Hub first:
docker login

echo 📤 Pushing image: %IMAGE_NAME%:%TAG%
docker push %IMAGE_NAME%:%TAG%

echo ✅ Image pushed successfully to Docker Hub!
echo 🔗 Docker Hub URL: https://hub.docker.com/r/hafsa44969/cloud-pipeline-app