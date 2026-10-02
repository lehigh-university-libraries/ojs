#!/usr/bin/env bash
set -euo pipefail

target_url="${SITE_URL:-http://localhost:8888}"
password=$(<secrets/OJS_ADMIN_PASSWORD)
cookies=$(mktemp)
trap 'rm -f "$cookies"' EXIT

form=$(curl -fsS -c "$cookies" "${target_url%/}/index/login")
csrf=$(sed -n 's/.*name="csrfToken" value="\([^"]*\)".*/\1/p' <<< "$form")
maxlength=$(sed -n '/type="password"/s/.*maxlength="\([0-9]*\)".*/\1/p' <<< "$form")
test -n "$csrf"
if [[ -n "$maxlength" && ${#password} -gt "$maxlength" ]]; then
  echo "Admin secret exceeds the login form's $maxlength-character limit" >&2
  exit 1
fi

# Pass the password through stdin so it never appears in process arguments.
status=$(printf '%s' "$password" | curl -sS -b "$cookies" -c "$cookies" \
  -o /dev/null -w '%{http_code}' \
  --data-urlencode "csrfToken=$csrf" \
  --data-urlencode "username=${OJS_ADMIN_USERNAME:-admin}" \
  --data-urlencode 'password@-' \
  "${target_url%/}/index/login/signIn")
if [[ "$status" != 302 ]]; then
  echo "Admin login failed (HTTP $status)" >&2
  exit 1
fi
echo "Admin login works with the generated secret."
