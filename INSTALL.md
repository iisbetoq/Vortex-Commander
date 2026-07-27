# VORTEX Agent Commander — Install Guide

## Prerequisites
- Linux, `python3` 3.10+, `git`
- Hermes Agent:
  ```bash
  curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
  hermes model
  ```

## Install di mesin baru

```bash
# 1. Copy code
rsync -avz user@oldhost:/path/to/LA3/ ./LA3/ --exclude venv --exclude __pycache__ --exclude .git

# Atau git clone
git clone <repo-url> LA3

# 2. Setup (otomatis generate VORTEX_ADMIN_KEY + API_SERVER_KEY)
cd LA3
./install/install_local.sh
# Note: kalau backup dari mesin lama, timpa ~/.hermes/.env setelah install_local.sh

# 3. Backup database (kalau mau bawa data lama)
rsync user@oldhost:/path/to/LA3/data/app.db ./data/app.db

# 4. Jalankan
./run_local.sh start
```

## Install production (VPS)
```bash
sudo ./install/install.sh
```
Login key tercetak di akhir install.

## Backup
File/folder yang perlu dibackup ke mesin baru:

| Path | Keterangan |
|---|---|
| `data/app.db` | Semua agent, chats, messages, settings |
| `~/.hermes/.env` | `VORTEX_ADMIN_KEY`, `API_SERVER_KEY` |
| `~/.hermes/skills/vortex-*/` | Skill files per agent (bisa regenerated dari DB) |
| Seluruh repo LA3 | Kode (exclude `venv/`, `__pycache__/`, `.git/`) |

## Access
- Web UI: `http://<ip>:61318`
- Login: `VORTEX_ADMIN_KEY` dari `~/.hermes/.env`

## Manage
```bash
./run_local.sh start|stop|restart|status|logs
```

## Rebrand
```bash
python3 set_brand.py "Nama Agent Kamu"
```
