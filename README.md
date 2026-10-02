# Open Journal Systems (OJS) Docker Container

Docker Compose deployment of [Open Journal Systems](https://pkp.sfu.ca/software/ojs/) using `ghcr.io/lehigh-university-libraries/ojs:php83`, published by [Lehigh buildkit](https://github.com/lehigh-university-libraries/buildkit/tree/main/images/ojs). Lehigh's custom plugins and themes are mounted read-only alongside the image's stock plugins. This repository does not build or publish images. Traefik includes the custom captcha-protect plugin; MariaDB and Mailpit are provided by the local development override.

# Requirements

- [Docker 24.0+](https://docs.docker.com/get-docker/) **Referring to the Docker Engine version, not Docker Desktop**.
- [Docker Compose](https://docs.docker.com/compose/install/linux/) **Already included in Mac OS with Docker**

## Quick Start (local development)

1. Setup repo
```bash
git clone https://github.com/lehigh-university-libraries/ojs
cd ojs
cp compose.override-example.yaml compose.override.yaml
```

2. Start the containers:
```bash
make deps
make up
```

3. Access OJS at http://localhost:8888

The development override supplies Cloudflare's public Turnstile test keys. Production must use real `TURNSTILE_PUBLIC_KEY` and `TURNSTILE_PRIVATE_KEY` values in `.env`.

The installation will run automatically on first startup. The default admin credentials are:
- Username: `admin` (configurable via `OJS_ADMIN_USERNAME` on the OJS service)
- Password: Contents of `./secrets/OJS_ADMIN_PASSWORD`
- Email: `admin@localhost` (configurable via `OJS_ADMIN_EMAIL`)

New admin passwords are 32 hexadecimal characters to fit OJS's login form.
The secret is used only when creating the initial account; changing the file
later does not change the password stored in an existing database.

## Configuration

### OJS Configuration

| Environment Variable | Default | Source | Description |
| :------------------- | :------ | :----- | :---------- |
| DB_HOST | mariadb | environment | MariaDB/MySQL hostname |
| DB_PORT | 3306 | environment | MariaDB/MySQL port |
| DB_NAME | ojs | environment | Database name |
| DB_USER | ojs | environment | Database user |
| DB_PASSWORD | (generated) | secret | Database password (stored in `./secrets/OJS_DB_PASSWORD`), only given to the `ojs` app container |
| DB_ROOT_PASSWORD | (generated) | secret | MariaDB root password (stored in `./secrets/DB_ROOT_PASSWORD`), only given to `mariadb` and the one-shot `database-init` service |
| OJS_SALT | (generated) | secret | Salt for password hashing (stored in `./secrets/OJS_SALT`) |
| OJS_API_KEY_SECRET | (generated) | secret | Secret for API key encoding (stored in `./secrets/OJS_API_KEY_SECRET`) |
| OJS_SECRET_KEY | (generated) | secret | Application-encryption key, a `base64:`-prefixed 32-byte value (stored in `./secrets/OJS_SECRET_KEY`). Not an arbitrary password — replacing it with a different-length string prevents OJS from serving requests, and rotating it can invalidate encrypted application data. |
| OJS_ADMIN_USERNAME | admin | environment | Initial admin username |
| OJS_ADMIN_EMAIL | admin@localhost | environment | Initial admin email |
| OJS_ADMIN_PASSWORD | (generated) | secret | Initial admin password (stored in `./secrets/OJS_ADMIN_PASSWORD`) |
| OJS_OAI_REPOSITORY_ID | localhost | environment | OAI-PMH repository identifier, set from `DOMAIN` |
| OJS_ENABLE_BEACON | 1 | environment | Enable PKP usage statistics beacon (1=enabled, 0=disabled) |
| OJS_SMTP_SERVER / OJS_SMTP_PORT | (empty) / 25 | environment | Outbound mail relay |
| OJS_DEFAULT_ENVELOPE_SENDER | noreply@journals.lehigh.edu | environment | Envelope sender for outbound mail |
| INGRESS_HOSTNAMES | localhost | environment | Comma-separated public hostnames used to build `base_url` and `allowed_hosts`; set from `DOMAIN` |
| INGRESS_SCHEME | https | environment | `http` or `https`, drives `base_url` and PHP's forwarded-proto handling |

Runtime config (`config.inc.php`) is rendered from these values by the base image's `confd` templates at container start — there is no separate `OJS_BASE_URL`/`OJS_ENABLE_HTTPS` env var to set.

### Production with external MySQL

Use `compose.yaml` without the local development override. The base deployment starts only OJS and Traefik; it has no dependency on a local MariaDB or database initialization service. Set the existing database connection in `.env`:

```dotenv
DOMAIN=journals.lehigh.edu
DB_HOST=mysql.example.edu
DB_PORT=3306
DB_NAME=ojs
DB_USER=ojs
```

Provision the database and application user on the external server, and put its password in `secrets/OJS_DB_PASSWORD`. Preserve the existing OJS secrets and uploaded-file volumes. `make init` preserves nonempty secrets; the root password declaration is only used by the local development database and is never mounted into OJS. The image checks the configured database, recognizes an existing installation, and installs OJS only when its tables are absent. It connects using the application account and does not require MySQL root credentials.

A mounted startup wrapper (`scripts/ojs-setup.sh`) uses PHP `mysqli` for readiness and installation detection, matching OJS itself. This supports MySQL 8 authentication even though the image's MariaDB CLI lacks the `caching_sha2_password` plugin. The image still handles installation, config rendering, and permissions. Remove the wrapper once the published image provides equivalent checks.

```bash
COMPOSE_FILE=compose.yaml make deps up
```

The PR renames `docker-compose.yaml` to `compose.yaml` and moves plugin sources from `rootfs/var/www/ojs/plugins/` to `plugins/`. Update any deployment overrides that reference the old paths, and keep the existing Compose project name so named data volumes are reused. When the application version changes, follow the [application upgrade rollout](#application-upgrade-rollout) below. Startup does not perform schema upgrades.

### Nginx and PHP Settings

Nginx, PHP-FPM, and the s6 process supervision all ship inside the published OJS image. Tune them with the standard `NGINX_*`/`PHP_*` environment variables documented on that image; this repo does not carry its own nginx/php config.

## Secrets Management

Secrets are stored in the `./secrets/` directory and mounted into containers at runtime. `make init` (or `make up`) runs the `init` service, which uses `generate-compose-secrets.sh` (from the `ghcr.io/lehigh-university-libraries/base` image) to create a secure random value for each secret declared in `compose.yaml`, in the format each secret needs (`OJS_SECRET_KEY` gets the `base64:`-prefixed 32-byte format OJS requires). It then validates `OJS_SECRET_KEY` with `scripts/validate-ojs-secret-key.sh`.

## Customization

You can customize the installation by:

1. Setting environment variables on the `ojs` service in `compose.yaml`
2. Adding custom plugins to `plugins/`

### Adding Plugins

The published OJS image already ships OJS core and its stock plugins/themes. Place only Lehigh-specific plugin directories under `plugins/`, matching the subdirectory OJS expects:

- `blocks/` - Block plugins
- `gateways/` - Gateway plugins
- `generic/` - Generic plugins
- `importexport/` - Import/export plugins (e.g. `quickSubmit`)
- `metadata/` - Metadata plugins
- `oaiMetadataFormats/` - OAI metadata format plugins
- `paymethod/` - Payment method plugins
- `pubIds/` - Public identifier plugins
- `reports/` - Report plugins
- `themes/` - Theme plugins (`lrsj`, `lehigh`, `healthSciences`)

`compose.yaml` mounts `quickSubmit`, `healthSciences`, `lehigh`, and `lrsj` individually, read-only. Add a matching bind mount for each new plugin; mounting the entire `plugins/` directory would hide the stock plugins. Install any new plugin's dependencies before mounting it. After changing plugin code, restart OJS to refresh PHP's opcode cache (`docker compose restart ojs`).

## Volumes

The following volumes are created for data persistence:

- `mariadb-data` - Local development MariaDB database files
- `ojs-cache` - OJS cache files
- `ojs-files` - Uploaded files (submissions, etc.)
- `ojs-public` - Public files

## Application upgrade rollout

OJS core and PHP are maintained in [Lehigh buildkit](https://github.com/lehigh-university-libraries/buildkit/tree/main/images/ojs). **The image installs an empty database but does not upgrade an existing schema.** Pulling/recreating containers, `make up`, and the systemd unit do not run `tools/upgrade.php upgrade`. The systemd unit's `rollout.lock` is only a marker; it does not put the site into maintenance mode.

Use the production Compose configuration and existing project name throughout. Keep the external MySQL connection, secrets, and named volumes; do not enable the local development override or run `make clean` during a rollout.

1. Confirm the supported upgrade path for the current and target OJS releases and compatibility of the mounted plugins/themes. Record the current Git revision and image digest. Update the OJS image reference in `compose.yaml` to the reviewed target digest: `docker compose pull` alone cannot advance a digest-pinned image.

2. Put the public ingress into maintenance mode, pause any external jobs that write to OJS, and stop the web containers:

   ```bash
   docker compose stop traefik ojs
   ```

   Take a consistent, restorable backup of the **external MySQL database**, `ojs-files`, `ojs-public`, deployment configuration, and secrets before starting the new version. Preserve these together for rollback.

3. Pull and start only OJS, leaving public traffic blocked:

   ```bash
   docker compose pull ojs
   docker compose up -d --no-deps ojs
   docker compose logs -f ojs
   ```

   Wait for startup/setup to finish, then leave log-following with Ctrl-C. An HTTP health check can fail while the new code still sees an old schema; do not reopen traffic based on container startup alone.

4. Run the database upgrade explicitly, once, using the configured application database account:

   ```bash
   docker compose exec -T --user nginx ojs php tools/upgrade.php upgrade
   docker compose exec -T --user nginx ojs php tools/upgrade.php check
   ```

   Proceed only after the upgrade succeeds and the check shows matching code and database versions. The database account must have the permissions required by the release's migrations; OJS does not need the MySQL root password mounted into its container. If the upgrade fails, keep the site offline and inspect the error before retrying.

5. Wait for OJS health, then restore Traefik while the public ingress remains in maintenance mode:

   ```bash
   docker compose up -d --no-deps --wait --wait-timeout 1200 ojs
   docker compose up -d --wait traefik
   ```

   Verify journal pages, admin login, submission/file access, and custom themes/plugins through maintenance access. Check the logs, then reopen public traffic and resume external jobs.

**Rollback:** keep traffic blocked, stop OJS, restore the matching database and file backups, and restore the previous Git revision/image digest and configuration before restarting. Reverting the image alone does not undo database migrations. Preserve the original application secrets; regenerating them can invalidate encrypted data.

## Troubleshooting

### Installation Logs

If the automatic installation fails, check the container logs:

```bash
docker compose logs ojs
```

### Database Connection Issues

Ensure the MariaDB and `database-init` containers are healthy/completed before the OJS container starts:

```bash
docker compose ps
```

### Resetting Installation

To completely reset and reinstall:

```bash
make clean
make up
```

## License

This Docker implementation is provided as-is. Open Journal Systems is licensed under the GNU General Public License v3. See the [OJS repository](https://github.com/pkp/ojs) for details.
