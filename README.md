# Open Journal Systems (OJS) Docker Container

Dockerized deployment of [Open Journal Systems](https://pkp.sfu.ca/software/ojs/), built on top of the [LibOps `libops/ojs`](https://github.com/libops/ojs) application image. This repo layers Lehigh's custom plugins and themes onto that base image and runs it with Traefik (including a custom captcha-protect plugin) and MariaDB via Docker Compose.

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
make up
```

3. Access OJS at http://localhost:8888

The installation will run automatically on first startup. The default admin credentials are:
- Username: `admin` (configurable via `OJS_ADMIN_USERNAME` on the OJS service)
- Password: Contents of `./secrets/OJS_ADMIN_PASSWORD`
- Email: `admin@example.com` (configurable via `OJS_ADMIN_EMAIL`)

## Configuration

### OJS Configuration

| Environment Variable | Default | Source | Description |
| :------------------- | :------ | :----- | :---------- |
| DB_HOST | mariadb | environment | MariaDB/MySQL hostname |
| DB_NAME | ojs | environment | Database name |
| DB_USER | ojs | environment | Database user |
| DB_PASSWORD | (generated) | secret | Database password (stored in `./secrets/OJS_DB_PASSWORD`), only given to the `ojs` app container |
| DB_ROOT_PASSWORD | (generated) | secret | MariaDB root password (stored in `./secrets/DB_ROOT_PASSWORD`), only given to `mariadb` and the one-shot `database-init` service |
| OJS_SALT | (generated) | secret | Salt for password hashing (stored in `./secrets/OJS_SALT`) |
| OJS_API_KEY_SECRET | (generated) | secret | Secret for API key encoding (stored in `./secrets/OJS_API_KEY_SECRET`) |
| OJS_SECRET_KEY | (generated) | secret | Application-encryption key, a `base64:`-prefixed 32-byte value (stored in `./secrets/OJS_SECRET_KEY`). Not an arbitrary password — replacing it with a different-length string prevents OJS from serving requests, and rotating it can invalidate encrypted application data. |
| OJS_ADMIN_USERNAME | admin | environment | Initial admin username |
| OJS_ADMIN_EMAIL | admin@example.com | environment | Initial admin email |
| OJS_ADMIN_PASSWORD | (generated) | secret | Initial admin password (stored in `./secrets/OJS_ADMIN_PASSWORD`) |
| OJS_OAI_REPOSITORY_ID | localhost | environment | OAI-PMH repository identifier, set from `DOMAIN` |
| OJS_ENABLE_BEACON | 1 | environment | Enable PKP usage statistics beacon (1=enabled, 0=disabled) |
| OJS_SMTP_SERVER / OJS_SMTP_PORT | (empty) / 25 | environment | Outbound mail relay |
| OJS_DEFAULT_ENVELOPE_SENDER | noreply@journals.lehigh.edu | environment | Envelope sender for outbound mail |
| INGRESS_HOSTNAMES | localhost | environment | Comma-separated public hostnames used to build `base_url` and `allowed_hosts`; set from `DOMAIN` |
| INGRESS_SCHEME | https | environment | `http` or `https`, drives `base_url` and PHP's forwarded-proto handling |

Runtime config (`config.inc.php`) is rendered from these values by the base image's `confd` templates at container start — there is no separate `OJS_BASE_URL`/`OJS_ENABLE_HTTPS` env var to set.

### Nginx and PHP Settings

Nginx, PHP-FPM, and the s6 process supervision all ship inside the `libops/ojs` base image. Tune them with the standard `NGINX_*`/`PHP_*` environment variables documented on that image; this repo does not carry its own nginx/php config.

## Secrets Management

Secrets are stored in the `./secrets/` directory and mounted into containers at runtime. `make init` (or `make up`) runs the `init` service, which uses `generate-compose-secrets.sh` (from the `libops/base` image) to create a secure random value for each secret declared in `compose.yaml`, in the format each secret needs (`OJS_SECRET_KEY` gets the `base64:`-prefixed 32-byte format OJS requires). It then validates `OJS_SECRET_KEY` with `scripts/validate-ojs-secret-key.sh`.

## Customization

You can customize the installation by:

1. Setting environment variables on the `ojs` service in `compose.yaml`
2. Adding custom plugins to `plugins/`

### Adding Plugins

The `libops/ojs` base image already ships OJS core and its stock plugins/themes. Place only Lehigh-specific plugin directories under `plugins/`, matching the subdirectory OJS expects:

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

The Dockerfile copies this whole tree over the base image's plugin directories at build time (`COPY --link --chown=100:101 plugins/ /var/www/ojs/plugins/`); rebuild and redeploy after changing a checked-in plugin.

## Volumes

The following volumes are created for data persistence:

- `mariadb-data` - MariaDB database files
- `ojs-cache` - OJS cache files
- `ojs-files` - Uploaded files (submissions, etc.)
- `ojs-public` - Public files

## Updating OJS Version

OJS core lives in the upstream `libops/ojs` base image, not in this repo. To move to a newer OJS/PHP release, update the `BASE_IMAGE` build arg (and its digest) at the top of the `Dockerfile`:

```dockerfile
ARG BASE_IMAGE=libops/ojs:3.5.0-5-php84@sha256:...
```

Back up the database and the `ojs-files`/`ojs-public` volumes before an application upgrade.

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
