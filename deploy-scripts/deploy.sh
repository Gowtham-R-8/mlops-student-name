
#!/bin/sh
set -eu

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
i=1

while [ "$i" -le 30 ]; do
  echo "Health check attempt $i of 30"

  if curl --connect-timeout 3 --max-time 5 -fsS \
      http://127.0.0.1:8080/health; then
    echo
    echo "SUCCESS: Student Result Predictor is healthy."
    exit 0
  fi

  echo "Application is not ready yet. Waiting 2 seconds..."
  sleep 2
  i=$((i + 1))
done

echo "ERROR: Health check failed after 30 attempts."
echo "Container status:"
sudo docker ps -a

echo "Container logs:"
sudo docker logs --tail 100 student-app || true

exit 1
