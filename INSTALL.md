# VORTEX Agent Commander — Install Guide

## Prerequisites
- Linux, Python 3.10+, git
- Hermes Agent (required):
  ```bash
  curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
  hermes model
  ```

## Local dev install

```bash
./install/install_local.sh          # creates venv, installs deps, generates keys
./run.sh start                # starts gateway + backend
```

The script auto-generates `VORTEX_ADMIN_KEY` and `API_SERVER_KEY` in `~/.hermes/.env` if they don't exist yet. The login key is printed at the end.

## Production install (VPS)

```bash
sudo ./install/install.sh
```

This provisions a fresh VPS: installs Hermes, sets up systemd services, Caddy reverse proxy, and UFW firewall. The login key is printed at the end.

## Moving to a new machine

```bash
# On the OLD machine, create a backup tarball:
./scripts/backup.sh

# Copy vortex-commander-backup.tar.gz to the new machine, then:
tar xzf vortex-commander-backup.tar.gz
./restore.sh
cd commander && ./run.sh start
```

### What gets backed up

| Path | Description |
|---|---|
| `commander/` | All source code (excluding venv, __pycache__, .git) |
| `app.db` | SQLite database — agents, chats, messages, settings |
| `hermes/.env` | `VORTEX_ADMIN_KEY`, `API_SERVER_KEY`, Hermes config |
| `hermes/config.yaml` | Hermes model & provider settings |
| `hermes/skills/vortex-*/` | Per-agent skill files |

## Access
- Web UI: `http://<ip>:61318`
- Login: `VORTEX_ADMIN_KEY` from `~/.hermes/.env`

## Managing the service
```bash
./run.sh start|stop|restart|status|logs
```

## Rebranding
```bash
python3 set_brand.py "Your Agent Name"
```
