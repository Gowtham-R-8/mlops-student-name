#!/bin/bash
set -e
if docker ps -a --format '{{.Names}}' | grep -qx 'student-result-predictor'; then
  docker rm -f student-result-predictor || true
fi
