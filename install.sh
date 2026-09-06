#!/usr/bin/env bash

set -euo pipefail

echo "Installing SysGuard System Monitoring Engine..."

mkdir -p /etc/sysguard
cp -r config/* /etc/sysguard/
cp bin/sysguard /usr/local/bin/sysguard
chmod +x /usr/local/bin/sysguard

if [[ -d /etc/systemd/system ]]; then
    cp systemd/sysguard.service /etc/systemd/system/
    cp systemd/sysguard.timer /etc/systemd/system/
    echo "Systemd service files placed successfully."
fi

echo "SysGuard installed. Run 'sysguard --check' to verify installation."
