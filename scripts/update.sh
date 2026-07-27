#!/bin/sh
set -e

cd /root/vortex
before=$(git rev-parse HEAD)
git pull --ff-only
after=$(git rev-parse HEAD)

if [ "$before" != "$after" ]; then
./venv/bin/pip install -r install/backend_requirements.txt
systemctl restart vortex-backend.service
fi
