# VORTEX Agent Commander — Install Guide

## 1. Clone the repository

Open a terminal and run:

```bash
git clone https://github.com/iisbetoq/Vortex-Commander.git
cd Vortex-Commander
```

> If you don't have git installed yet:
> ```bash
> sudo apt install git -y       # Ubuntu / Debian
> sudo dnf install git -y       # Fedora
> ```

## 2. Install Hermes Agent (required)

```bash
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
```

Close and reopen your terminal, then set up a model:

```bash
hermes model
```

## 3. Install VORTEX Commander

```bash
./install/install.sh
```

You'll be asked to choose: **VPS** or **Local**?

| Mode   | When to use                     | What it does                           |
|--------|---------------------------------|----------------------------------------|
| Local  | Your own PC / laptop            | Creates venv, installs deps, no sudo   |
| VPS    | Cloud / production server       | Installs systemd, firewall, Caddy proxy |

Pick **Local** if you're installing on your personal machine.

## 4. Start

```bash
./run.sh start
```

Wait a few seconds, then open your browser:

```
http://127.0.0.1:61318
```

The **login key** can be found with:

```bash
grep VORTEX_ADMIN_KEY ~/.hermes/.env
```

## Commands

```bash
./run.sh start       # Start the stack
./run.sh stop        # Stop everything
./run.sh restart     # Restart
./run.sh status      # Check status
./run.sh logs        # View live logs
```

## Backup & migrate

```bash
# On the old machine:
./scripts/backup.sh
# Produces: vortex-commander-backup.tar.gz

# On the new machine:
tar xzf vortex-commander-backup.tar.gz
cd commander && ./run.sh start
```

## Rebranding

```bash
python3 set_brand.py "Your Agent Name"
```
