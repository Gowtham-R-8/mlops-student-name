
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

echo "Waiting for the health endpoint..."
for i in {1..30}; do
  if curl --connect-timeout 3 -fsS \
    http://127.0.0.1:8080/health; then
    echo
    echo "Health check succeeded."
    exit 0
  fi

  echo "Attempt $i failed; waiting for application startup..."
  sleep 2
done

echo "Health check failed. Diagnostics:"
sudo docker ps -a
sudo docker logs --tail 100 student-app
exit 1
