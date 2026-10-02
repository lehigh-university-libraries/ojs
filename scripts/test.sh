#!/usr/bin/env bash

set -eou pipefail

target_url="${SITE_URL:-http://localhost:8888/}"

docker compose exec -T ojs /command/with-contenv php -r '
  if (PHP_MAJOR_VERSION !== 8 || PHP_MINOR_VERSION !== 3) {
    throw new RuntimeException("Expected PHP 8.3");
  }
  $config = parse_ini_file("config.inc.php", true);
  foreach (["host", "port", "name", "username"] as $key) {
    $env = "DB_" . ($key === "username" ? "USER" : strtoupper($key));
    if ((string) $config["database"][$key] !== getenv($env)) {
      throw new RuntimeException("Database configuration mismatch: " . $key);
    }
  }
  foreach (["themes/default", "themes/lehigh", "themes/lrsj", "themes/healthSciences", "importexport/quickSubmit"] as $plugin) {
    if (!is_readable("plugins/" . $plugin . "/version.xml")) {
      throw new RuntimeException("Missing plugin: " . $plugin);
    }
  }
'

if ! curl -fsS "${target_url}" | grep "<img" | grep -q "Open Journal Systems"; then
  docker compose logs
  echo "Failed to detect OJS at ${target_url}"
  exit 1
fi

echo "OJS is up!"
