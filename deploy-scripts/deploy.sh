
#!/bin/bash
set -e

APP_DIR="/home/ubuntu/mlops-student-name"
cd "$APP_DIR"

echo "Building Student Result Predictor image..."
sudo docker build -t student-app:latest .

echo "Removing previous Student Result Predictor container..."
sudo docker rm -f student-app 2>/dev/null || true

echo "Starting Student Result Predictor on port 8080..."
sudo docker run -d \
  --name student-app \
  --restart unless-stopped \
  -p 8080:5000 \
  -e MODEL_VERSION=2.0 \
  student-app:latest

echo "Checking application health..."
for i in {1..15}; do
  if curl -fsS http://127.0.0.1:8080/health; then
    echo "Student Result Predictor is running."
    exit 0
  fi
  sleep 2
done

echo "Health check failed."
sudo docker logs student-app
exit 1
