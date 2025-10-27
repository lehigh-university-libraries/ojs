#!/command/with-contenv bash
# shellcheck shell=bash

set -eou pipefail

function set_ojs_installed {
    sed -i 's/installed = Off/installed = On/' /var/www/ojs/config.inc.php
    chmod 440 /var/www/ojs/config.inc.php
}

function main {
    # wait for nginx
    if ! timeout 300 wait-for-open-port.sh localhost 80; then
      echo "Could not connect to nginx at localhost:80"
      exit 1
    fi
    set_ojs_installed
}
main
