#!/usr/bin/env bash

set -eou pipefail

max_attempts=10
attempt=0

while [ $attempt -lt $max_attempts ]; do
  attempt=$(( attempt + 1 ))
  echo "Attempt $attempt of $max_attempts..."
  
  sleep 10
  
  if curl -sf http://localhost:8888/ | grep "<img" | grep -q "Open Journal Systems"; then
    echo "OJS is up!"
    exit 0
  fi
  sleep 60
  docker compose logs ojs --tail 20
done

docker compose logs ojs

echo "Failed to detect OJS after $max_attempts attempts"
exit 1
