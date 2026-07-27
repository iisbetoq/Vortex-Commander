#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

BACKUP_DIR="${1:-./backup}"
mkdir -p "$BACKUP_DIR"

echo "==> Backing up VORTEX Commander to $BACKUP_DIR"

# 1. Repo code
echo "==> Copying repo..."
rsync -a --delete \
  --exclude venv --exclude __pycache__ --exclude .git \
  --exclude '*.pyc' --exclude data --exclude xxxcontoh \
  ./ "$BACKUP_DIR/commander/"

# 2. Database
if [ -f data/app.db ]; then
  echo "==> Copying database..."
  cp data/app.db "$BACKUP_DIR/app.db"
fi

# 3. Hermes env + config
mkdir -p "$BACKUP_DIR/hermes"
for f in .env config.yaml; do
  if [ -f ~/.hermes/"$f" ]; then
    echo "==> Copying Hermes $f..."
    cp ~/.hermes/"$f" "$BACKUP_DIR/hermes/"
  fi
done

# 4. Agent skill folders
if ls ~/.hermes/skills/vortex-*/SKILL.md >/dev/null 2>&1; then
  echo "==> Copying agent skill folders..."
  mkdir -p "$BACKUP_DIR/hermes/skills"
  for d in ~/.hermes/skills/vortex-*/; do
    cp -r "$d" "$BACKUP_DIR/hermes/skills/"
  done
fi

# 5. Restore script
cat > "$BACKUP_DIR/restore.sh" << 'RESTORE'
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

echo "==> Restoring VORTEX Commander..."
echo ""

# Hermes
mkdir -p ~/.hermes/skills
if [ -f hermes/.env ]; then
  cp hermes/.env ~/.hermes/.env
  echo "  ~/.hermes/.env restored"
fi
if [ -f hermes/config.yaml ]; then
  cp hermes/config.yaml ~/.hermes/config.yaml
  echo "  ~/.hermes/config.yaml restored"
fi
if ls hermes/skills/vortex-*/SKILL.md >/dev/null 2>&1; then
  cp -r hermes/skills/vortex-* ~/.hermes/skills/
  echo "  skill folders restored"
fi

# Database
mkdir -p commander/data
if [ -f app.db ]; then
  cp app.db commander/data/app.db
  echo "  database restored"
fi

# Setup
cd commander
echo ""
echo "==> Installing backend..."
./install/install_local.sh
echo ""
echo "==> Done. Run:  ./run_local.sh start"
RESTORE
chmod +x "$BACKUP_DIR/restore.sh"

# 6. Package
echo "==> Creating tarball..."
tar czf vortex-commander-backup.tar.gz -C "$BACKUP_DIR" .
rm -rf "$BACKUP_DIR"

ADMIN_KEY="$(grep '^VORTEX_ADMIN_KEY=' ~/.hermes/.env 2>/dev/null | head -1 | cut -d= -f2)"
echo "==> Done: vortex-commander-backup.tar.gz ($(du -h vortex-commander-backup.tar.gz | cut -f1))"
echo ""
echo "---"
echo "On a NEW machine (no Hermes):"
echo ""
echo "  # 1. Install Hermes"
echo "  curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash"
echo "  hermes model"
echo ""
echo "  # 2. Extract & restore"
echo "  tar xzf vortex-commander-backup.tar.gz"
echo "  ./restore.sh"
echo ""
echo "  # 3. Start"
echo "  cd commander && ./run_local.sh start"
echo ""
echo "Login key: ${ADMIN_KEY}"
