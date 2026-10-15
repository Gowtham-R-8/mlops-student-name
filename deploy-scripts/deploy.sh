
#!/bin/bash
set -e

APP_DIR="/home/ubuntu/mlops-student-predictor"

echo "Starting Student Result Predictor deployment..."

# Install Docker if it is missing
if ! command -v docker >/dev/null 2>&1; then
    apt-get update -y
    apt-get install -y docker.io
fi

systemctl enable --now docker

# Build the latest application image
cd "$APP_DIR"
docker build -t student-app .

# Replace the old container
docker rm -f student-app 2>/dev/null || true

# Start the new application
docker run -d \
    --name student-app \
    --restart unless-stopped \
    -p 80:5000 \
    student-app

# Verify deployment
sleep 3
docker ps --filter "name=student-app"
curl --fail http://127.0.0.1/ >/dev/null

echo "Student Result Predictor deployment successful."
