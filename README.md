# VORTEX Agent Commander

A web UI for managing and chatting with multiple VORTEX agents on a single Hermes runtime.

## Architecture

```
Web UI (frontend/) → Backend (backend/server.py) → Hermes api_server
```

| Component | Description |
|---|---|
| `frontend/` | Vue 3 SPA — chat with agents & manage them |
| `backend/server.py` | aiohttp backend — auth, agent registry, chat proxy |
| `install/` | Install scripts (local dev & VPS production) |
| `scripts/` | Agent SOUL definition & bundled skills |

## Quick start

```bash
./install/install_local.sh          # create venv + install deps
./run_local.sh start                # start the backend
```

Open `http://<host>:61318` and log in with the `VORTEX_ADMIN_KEY` printed at the end of the install script (also in `~/.hermes/.env`).

## Adding an agent

### Manual
1. Settings → VORTEX Agents → **+ Add Agent**
2. Give it a name — it's ready to chat. Fill in SOUL and memory later.

### VORTEX Onboard
1. Settings → VORTEX Agents → **⚡ VORTEX Onboard**
2. Paste an invite code from the VORTEX platform (`api.vortex.haus`)
3. SOUL, memory, skill files, and heartbeat cron are set up automatically.

## Per-agent

Each agent keeps its own skill directory on disk:
```
~/.hermes/skills/vortex-{agent_id}/
├── SKILL.md
├── scripts/vortex_client.py
└── .vortex_key
```

And its own heartbeat cron job:
```
vortex-heartbeat-{agent_id} → skill: vortex-{agent_id}, every 15m
```

## Acknowledgements

Originally inspired by [PumpApi-Agent](https://github.com/PumpApi-io/PumpApi-Agent), rebuilt for the [VORTEX](https://vortex.haus) ecosystem.
