#!/bin/sh
# VORTEX Commander — VPS provisioning script
# Usage: sudo ./install/install.sh
set -x
export DEBIAN_FRONTEND=noninteractive

REPO="/root/vortex"
ADMIN_KEY=$(python3 -c "import secrets; print(secrets.token_hex(24))")

apt-get update -y
apt-get -y \
  -o Dpkg::Options::="--force-confdef" \
  -o Dpkg::Options::="--force-confold" \
  upgrade

apt install -y python3-venv python3 nodejs npm openssl

# ---- Hermes Agent ----
curl -fsSL --retry 200 --retry-delay 61 --retry-all-errors \
  https://hermes-agent.nousresearch.com/install.sh | bash
export PATH="$HOME/.local/bin:$PATH"
hermes config set approvals.mode off
hermes config set browser.provider local
hermes config set prompt_caching.cache_ttl 1h

# ---- Hermes api_server keys ----
mkdir -p /root/.hermes
cat > /root/.hermes/.env <<EOF
API_SERVER_ENABLED=true
API_SERVER_HOST=127.0.0.1
API_SERVER_PORT=61317
API_SERVER_KEY=${ADMIN_KEY}
VORTEX_ADMIN_KEY=${ADMIN_KEY}
EOF

yes | hermes gateway install --system --run-as-user root
systemctl enable --now hermes-gateway

# ---- VORTEX backend ----
python3 -m venv "$REPO/venv"
"$REPO/venv/bin/pip" install -r "$REPO/install/backend_requirements.txt"

# ---- Backend systemd service ----
sed "s|%REPO%|$REPO|g" "$REPO/install/systemd/vortex-backend.service" > /etc/systemd/system/vortex-backend.service
systemctl daemon-reload
systemctl enable --now vortex-backend.service

# ---- Firewall ----
apt install -y ufw
ufw allow 80
ufw allow 443
ufw --force enable

# ---- Caddy reverse proxy ----
apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' > /etc/apt/sources.list.d/caddy-stable.list
apt update -y
apt install -y caddy

PUBLIC_IP=$(hostname -I | awk '{print $1}')
cat > /etc/caddy/Caddyfile <<CADDYEOF
{
	auto_https disable_redirects
	cert_issuer acme { profile shortlived }
}

http://$PUBLIC_IP {
	reverse_proxy 127.0.0.1:61318
}

https://$PUBLIC_IP {
	reverse_proxy 127.0.0.1:61318
}
CADDYEOF

systemctl restart caddy

# ---- Hermes tools ----
hermes tools disable --platform telegram clarify
hermes tools enable --platform api_server terminal

echo ""
echo "================================================"
echo "  VORTEX Commander installed!"
echo ""
echo "  Web UI:    http://$PUBLIC_IP"
echo "  Login key: $ADMIN_KEY"
echo ""
echo "  Then open Settings -> VORTEX Agents to add agents."
echo "================================================"
