[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/alby-hub-1?utm_medium=integration&utm_source=button&utm_campaign=alby-hub)

# Alby Hub on Railway

A one-click [Railway](https://railway.com) template for [Alby Hub](https://github.com/getAlby/hub), the self-custodial Bitcoin Lightning node and wallet that connects to apps with Nostr Wallet Connect (NWC).

## What it deploys

| Service | Source | Notes |
|---|---|---|
| `Alby Hub` | this repo (`Dockerfile`) | `ghcr.io/getalby/hub:v1.24.7`, pinned by digest. Public domain, port `8080`, health check `/api/info` |

A Railway volume is mounted at `/data`. Alby Hub keeps everything there (`WORK_DIR=/data/albyhub`): the SQLite database, the encrypted seed, the LDK node's channel state and the logs. Redeploys and restarts keep it.

## Variables

| Variable | Default | Why |
|---|---|---|
| `SETUP_CODE` | `${{secret(16,...)}}` | Generated per deploy. First-time setup (and restoring a backup) needs it, so a stranger who finds your URL can't set up the hub before you do |
| `PORT` | `8080` | Port Alby Hub listens on |
| `RAILWAY_DEPLOYMENT_DRAINING_SECONDS` | `300` | Gives the Lightning node up to 5 minutes to shut down cleanly on redeploy (the same grace period as Alby's own compose file) |

The deploy asks for nothing.

## After deploy

1. Open the service's **Variables** tab in Railway and copy `SETUP_CODE`.
2. Open `https://YOUR-DOMAIN/?c=SETUP_CODE` (or open the URL and paste the code when asked).
3. Choose an unlock password and finish setup. Alby Hub encrypts your seed with this password. **Write down the recovery phrase** it shows you and keep it offline.
4. Then connect apps with NWC from the hub's App Store / Connections page.

After every redeploy or restart the Lightning node stays stopped until you open the hub and enter your unlock password. If you want it to start on its own, set `AUTO_UNLOCK_PASSWORD` on the service to your unlock password (the UI still asks for the password), and understand that anyone with access to your Railway project can then read it.

Optional settings (`LOG_LEVEL`, `RELAY`, `NETWORK`, `LN_BACKEND_TYPE` for an external LND/Phoenixd/CLN node, `DATABASE_URI` for Postgres) are listed in [Alby Hub's README](https://github.com/getAlby/hub#optional-configuration-parameters).

## Security notes

Alby's docs say Alby Hub is meant for private networks, and that a public instance should sit behind HTTPS with restricted access. Railway serves the hub over HTTPS. The setup code protects first setup, and every API call after that needs a token from the unlock password, so pick a long unique password. Keep your recovery phrase and the hub's channel backups: losing the volume without them can lose funds.

Don't scale this service beyond one replica: two copies of the same Lightning node at once can lose funds.

## Updates

The service builds from this repository. When a new Alby Hub version is out, this repo's `Dockerfile` gets the new pinned image and a `CHANGELOG.md` entry, and Railway shows an "update available" notice on your project. Read the [CHANGELOG](CHANGELOG.md) first, then apply the update from the Railway dashboard, and unlock the hub again afterwards. Alby Hub migrates its database on start.

## Local run

```sh
SETUP_CODE=$(openssl rand -hex 8) docker compose -f compose.test.yml up --build
# open http://localhost:8080/?c=THE-CODE-YOU-SET
```

Alby Hub is Apache-2.0 software by [Alby](https://github.com/getAlby). This repository only holds the Railway packaging.
