#!/bin/bash
set -euo pipefail
cd /opt/student-result-predictor

# Ensure Docker is available and running.
systemctl enable --now docker

# Rebuild from the newly deployed source.
docker build --pull -t student-result-predictor:latest .

# Replace the previous container.
docker rm -f student-result-predictor 2>/dev/null || true
docker run -d \
  --name student-result-predictor \
  --restart unless-stopped \
  -e MODEL_VERSION=1.0 \
  -p 80:5000 \
  student-result-predictor:latest

# Fail deployment if the container does not remain running.
sleep 3
docker ps --filter name=student-result-predictor --format '{{.Status}}' | grep -q Up
