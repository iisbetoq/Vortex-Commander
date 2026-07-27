#!/bin/sh
set -e

cd /root/vortex || cd /root/LA3
before=$(git rev-parse HEAD)
git pull --ff-only
after=$(git rev-parse HEAD)

if [ "$before" != "$after" ]; then
./venv/bin/pip install -r install/backend_requirements.txt
systemctl restart vortex-agent.service
python3 scripts/update_hermes_soul_and_skills.py
fi
