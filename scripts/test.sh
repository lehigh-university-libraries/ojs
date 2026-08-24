#!/usr/bin/env bash

set -eou pipefail

target_url="${SITE_URL:-http://localhost:8888/}"

if ! curl -fsS "${target_url}" | grep "<img" | grep -q "Open Journal Systems"; then
  docker compose logs
  echo "Failed to detect OJS at ${target_url}"
  exit 1
fi

echo "OJS is up!"
