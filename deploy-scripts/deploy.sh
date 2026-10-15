
#!/bin/bash
set -e

APP_DIR="/home/ubuntu/mlops-student-name"

echo "Starting Student Result Predictor deployment..."

export DEBIAN_FRONTEND=noninteractive

if ! command -v docker >/dev/null 2>&1; then
    apt-get update -y
    apt-get install -y docker.io
fi

systemctl enable --now docker

cd "$APP_DIR"

echo "Building Docker image..."
docker build -t student-app .

echo "Removing previous container..."
docker rm -f student-app 2>/dev/null || true

echo "Starting updated container..."
docker run -d \
    --name student-app \
    --restart unless-stopped \
    -p 80:5000 \
    -e MODEL_VERSION=2.0 \
    student-app

sleep 3

docker ps --filter "name=student-app"
curl --fail http://127.0.0.1/health

echo "Deployment successful."
