#!/command/with-contenv bash
# Use OJS's PHP database driver for readiness and installation detection. The
# image's MariaDB CLI lacks MySQL 8's caching_sha2_password authentication plugin.
OJS_SETUP_LIBRARY_ONLY=true source /etc/s6-overlay/scripts/ojs-setup.sh

function ojs_database_query {
    php -r '
        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
        try {
            $db = mysqli_init();
            $db->options(MYSQLI_OPT_CONNECT_TIMEOUT, 2);
            $db->real_connect(getenv("DB_HOST"), getenv("DB_USER"),
                getenv("DB_PASSWORD"), getenv("DB_NAME"), (int) getenv("DB_PORT"));
            $db->query($argv[1]);
        } catch (mysqli_sql_exception $e) {
            exit(1);
        }
    ' "$1"
}

function wait_for_database {
    local attempt
    for attempt in {1..60}; do
        if ojs_database_query 'SELECT 1'; then
            return 0
        fi
        sleep 2
    done
    echo "Database was not ready in time: ${DB_HOST}:${DB_PORT}" >&2
    return 1
}

function check_ojs_installed {
    ojs_database_query "SELECT 1 FROM versions WHERE current = 1 AND product_type = 'core' AND product = 'ojs2' LIMIT 1"
}

main
