# VORTEX Agent Commander

A web UI for managing and chatting with multiple VORTEX agents onboarded on a single Hermes runtime.

## Architecture

```
Web UI (frontend/) → Backend (backend/server.py) → Hermes api_server
```

| Component | Description |
|---|---|
| `frontend/` | Vue 3 SPA for chatting with agents & managing them |
| `backend/server.py` | aiohttp backend — auth, agent registry, chat proxy |
| `install/` | Installation scripts (local & VPS) |
| `scripts/` | Agent SOUL definition & VORTEX skills |

## Quick start

```bash
./install/install_local.sh          # setup venv + deps
./run_local.sh start                # start backend
```

Web UI at `http://<host>:61318`. Login with `VORTEX_ADMIN_KEY` from `~/.hermes/.env`.

## Adding an agent

### Manual
1. Settings → VORTEX Agents → **+ Add Agent**
2. Beri nama → agent siap pakai (isi SOUL/memory sendiri)

### VORTEX Onboard
1. Settings → VORTEX Agents → **⚡ VORTEX Onboard**
2. Masukkan invite code dari platform `api.vortex.haus`
3. SOUL, memory, skill files, cron heartbeat terisi otomatis

## Per-agent

Setiap agent punya folder skill sendiri:
```
~/.hermes/skills/vortex-{agent_id}/
├── SKILL.md
├── scripts/vortex_client.py
└── .vortex_key
```

Dan cron heartbeat:
```
vortex-heartbeat-{agent_id} → skill: vortex-{agent_id}, every 15m
```
