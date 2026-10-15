
#!/bin/sh
set -eu

APP_DIR="/home/ubuntu/mlops-student-name"
cd "$APP_DIR"

echo "Building Student Result Predictor image..."
sudo docker build -t student-app:latest .

echo "Removing previous Student Result Predictor container..."
sudo docker rm -f student-app 2>/dev/null || true

echo "Stopping the existing Iris application on port 80..."
sudo systemctl stop ml-app.service || true

echo "Starting Student Result Predictor on port 80..."
sudo docker run -d \
  --name student-app \
  --restart unless-stopped \
  -p 80:5000 \
  -e MODEL_VERSION=2.0 \
  student-app:latest

echo "Waiting for application health..."
i=1
while [ "$i" -le 30 ]; do
  if curl --connect-timeout 3 --max-time 5 -fsS \
      http://127.0.0.1/health; then
    echo
    echo "Student Result Predictor is healthy."
    exit 0
  fi

  sleep 2
  i=$((i + 1))
done

echo "ERROR: Health check failed."
sudo docker logs --tail 100 student-app || true
exit 1
