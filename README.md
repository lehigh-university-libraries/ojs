# Open Journal Systems (OJS) Docker Container

Docker Compose deployment of [Open Journal Systems](https://pkp.sfu.ca/software/ojs/) using `ghcr.io/lehigh-university-libraries/ojs:php83`, published by [Lehigh buildkit](https://github.com/lehigh-university-libraries/buildkit/tree/main/images/ojs). Lehigh's custom plugins and themes are mounted read-only alongside the image's stock plugins. This repository does not build or publish images. Traefik includes the custom captcha-protect plugin; MariaDB and Mailpit are provided by the local development override.

# Requirements

- [Docker 24.0+](https://docs.docker.com/get-docker/) **Referring to the Docker Engine version, not Docker Desktop**.
- [Docker Compose 2.24.4+](https://docs.docker.com/compose/install/linux/) **Already included in Mac OS with Docker**

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

The development override clears the production IPAM settings so Docker allocates a local subnet without reserving `172.23.0.0/16`. Existing local overrides copied before this change need the same `networks.default.ipam: !reset null` entry.

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

### HAProxy and Galera on the Docker host

When HAProxy runs on the same Linux VM, set `DB_HOST=host.docker.internal` and
`DB_PORT=3306`. The app service maps that hostname using Docker's `host-gateway`.
On a standard Linux Engine this is the daemon's default bridge gateway, which is
separate from OJS's Compose bridge (`172.23.0.1`). Confirm the actual address:

```sh
docker network inspect bridge --format '{{(index .IPAM.Config 0).Gateway}}'
ip -4 address show docker0
sudo ss -ltnp '( sport = :3306 )'
```

Configure the existing HAProxy MySQL frontend to bind that gateway address and
port. Do not substitute `127.0.0.1` (unreachable from a bridge container) or a
project bridge that only appears after `docker compose up`. Keep the frontend
private and verify the host firewall permits the application containers. Avoid
binding MySQL to all interfaces just to solve boot ordering. These instructions
assume a conventional Docker default bridge; hosts with it disabled or a custom
`host-gateway-ip` need an explicitly managed listener address instead.

This failure was confirmed on `ojs-vm`: HAProxy attempted `172.23.0.1:3306`
before that address existed, failed five starts within two seconds, and reached
systemd's start limit. A later restart succeeded. The packaged unit orders
`network-online.target` but not Docker, and has no restart delay.

If HAProxy is bound to a Compose-created gateway, it can fail with "Cannot assign
requested address" on a fresh boot. Ordering it after Docker does not create
that project network. Ordering the application after HAProxy then creates a cycle:
the application creates the address HAProxy needs before it can start. Prefer the
stable daemon bridge above. If IT retains a custom bridge listener, provision the
network in a separate host-managed unit before HAProxy, declare it external in
Compose, and keep it when bringing application containers down.

For the default-bridge listener, an example HAProxy drop-in at
`/etc/systemd/system/haproxy.service.d/docker.conf` is:

```ini
[Unit]
Requires=docker.service
Wants=network-online.target
After=docker.service network-online.target

[Service]
RestartSec=5s
```

A minimal drop-in that preserves the packaged restart policy is supplied as
`scripts/systemd/haproxy-docker.conf`. After reviewing the current unit, an operator
can install it with:

```sh
sudo install -d /etc/systemd/system/haproxy.service.d
sudo install -m 0644 scripts/systemd/haproxy-docker.conf /etc/systemd/system/haproxy.service.d/docker.conf
sudo systemctl daemon-reload
sudo haproxy -c -f /etc/haproxy/haproxy.cfg
sudo systemctl reset-failed haproxy
sudo systemctl restart haproxy
```

Ordering after Docker fixes the missing dependency during normal reboot when the
bridge is restored; the delay prevents immediate retries from exhausting the start
limit. It does not create a missing project bridge on a new deployment. For the
long-term host-gateway approach, first verify the default bridge address, add it
to the HAProxy MySQL listener, reload HAProxy, and verify application connectivity
using `DB_HOST=host.docker.internal`. Only then remove the old `172.23.0.1` bind.
Keep `127.0.0.1:3306` if host processes use it. Review firewall rules during the
address change.

Review the installed unit and existing drop-ins before applying this example.
`network-online.target` does not wait for a Compose bridge or for Galera readiness.
The desired host ordering is Docker, then HAProxy, then the application startup
unit. Application startup can add `Requires=haproxy.service` and
`After=haproxy.service`; do not also order HAProxy after that application unit.
Docker restart policies can bring containers back before an application systemd
unit runs, so applications still need database retries. The supplied `ojs.service`
currently orders only Docker and runs `compose up -d`; it does not implement this
HAProxy ordering or wait for healthy application containers.

Keep the existing Galera backend configuration under IT management. Backend checks
must identify a writable node in the Primary component with `wsrep_ready=ON` and
`wsrep_connected=ON`; a TCP-open check alone cannot establish Galera readiness.
Use the cluster's established health-check mechanism and failover policy. The
application account needs its own database permissions, not administrative access.
OJS's PHP readiness probe uses that account and `SELECT 1`; it complements rather
than replaces the Galera-aware backend checks.

Collect evidence before changing a failing VM:

```sh
systemctl cat docker haproxy ojs
systemctl show haproxy -p After -p Requires -p Wants
journalctl -b -u docker -u haproxy -u ojs --no-pager
docker network ls
sudo haproxy -c -f /etc/haproxy/haproxy.cfg
COMPOSE_FILE=compose.yaml docker compose logs --tail=100 ojs
```

After an approved host change, verify a cold reboot, an application redeploy, a
Docker daemon restart, and loss/recovery of a Galera backend. Confirm HAProxy's
listener exists, the application can query through it, and port 3306 remains
unreachable from public interfaces. Never run these disruption tests against
production without a planned maintenance window.

References: [Docker host networking in Compose](https://docs.docker.com/compose/how-tos/networking/),
[systemd unit dependencies](https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html),
and [systemd network targets](https://systemd.io/NETWORK_ONLINE/).


#### Pin the host gateway

This host configuration is for production Linux VMs only. Do not apply it to
Docker Desktop or a local development engine; the application Compose overrides
do not change daemon settings.

The Linux VM standard is an explicit Docker default-bridge address of
`172.17.0.1/16`. Merge the setting from `scripts/docker/daemon.example.json`
into `/etc/docker/daemon.json`:

```json
{
  "bip": "172.17.0.1/16"
}
```

Preserve all other daemon settings, including an existing `data-root`. Do not
copy this fragment over an existing daemon configuration. Confirm the subnet
does not overlap host routes or other Docker networks, and reconcile any
`bridge`, `--bip`, or custom `host-gateway-ip` configuration. Do not assign this
same subnet to a Compose network.

After an approved Docker restart, verify `docker0` and `docker network inspect
bridge` show `172.17.0.1`. Compose continues using
`host.docker.internal:host-gateway`, which resolves to this daemon-level address
on these Linux VMs. Application networks can remain separate; OJS's existing
`172.23.0.1` project gateway is not this database listener address.

In the existing HAProxy `mysql-cluster` listener, retain the host loopback bind
if needed and use the pinned gateway:

```haproxy
bind 127.0.0.1:3306
bind 172.17.0.1:3306
```

Keep the existing Galera servers and health checks. Add and test the new bind
and application connection before removing the old `172.23.0.1` bind. On a
running VM, perform this migration only when the new address already exists;
otherwise HAProxy will reject the reload. The systemd drop-in orders HAProxy
after Docker so the pinned address is available at boot, independent of any
application Compose project. Apply daemon changes in a maintenance window;
`make up` does not alter host networking.

Docker documents the daemon's [`bip` setting](https://docs.docker.com/engine/network/drivers/bridge/#configure-the-default-bridge-network)
and [`host-gateway` resolution](https://docs.docker.com/reference/cli/dockerd/#configure-host-gateway-ip).

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

## Database backup copies

`db-backup` runs at 02:00 UTC, writing compressed SQL to `./backups/daily/`
and the latest successful dump of each month to `./backups/monthly/`.
It retains seven daily dates and the previous twelve completed months, plus the
current month's latest copy. Pruning runs only after a successful dump.
SET backs up Galera every 30 days; these additional copies are a LOCKSS
(Lots of Copies Keep Stuff Safe) precaution. They cover the configured application
database; uploaded files and other volumes still need their own backups.

The backup image is pinned by digest directly in Compose. Update that reference
when promoting a new published Buildkit `mysql-backup` image.
For an immediate dump: `docker compose exec db-backup /command/with-contenv mysql-backup.sh`.
See Buildkit's `images/mysql-backup/README.md` for restore instructions and limits.
