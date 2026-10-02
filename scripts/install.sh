#!/bin/bash
# ==============================================================================
# 🛡️ Proteção do Ubuntu - Installer Script (Clean & Prefix-Free)
# ==============================================================================

set -e

echo "=== Installing Proteção do Ubuntu Toolkit ==="

# 1. Copy scripts to /usr/local/bin
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "[*] Installing clean scripts to /usr/local/bin..."
cp "$SCRIPT_DIR"/security-monitor.sh /usr/local/bin/security-monitor
cp "$SCRIPT_DIR"/auto-remediate.sh /usr/local/bin/auto-remediate
cp "$SCRIPT_DIR"/incident-response.sh /usr/local/bin/incident-response
cp "$SCRIPT_DIR"/export-telemetry.py /usr/local/bin/export-telemetry
cp "$SCRIPT_DIR"/auto-harden.sh /usr/local/bin/auto-harden

chmod +x /usr/local/bin/security-monitor
chmod +x /usr/local/bin/auto-remediate
chmod +x /usr/local/bin/incident-response
chmod +x /usr/local/bin/export-telemetry
chmod +x /usr/local/bin/auto-harden

# Create clean short symlinks
ln -sf /usr/local/bin/security-monitor /usr/local/bin/monitor
ln -sf /usr/local/bin/auto-remediate /usr/local/bin/remediate
ln -sf /usr/local/bin/incident-response /usr/local/bin/incident
ln -sf /usr/local/bin/export-telemetry /usr/local/bin/telemetry
ln -sf /usr/local/bin/auto-harden /usr/local/bin/harden

# 2. Setup log directories
echo "[*] Creating incident response log directory (/var/log/security-incidents)..."
mkdir -p /var/log/security-incidents
chmod 700 /var/log/security-incidents

# 3. Optional Systemd Timer Setup
if [ -f "$SCRIPT_DIR/security-monitor.service" ] && [ -f "$SCRIPT_DIR/security-monitor.timer" ]; then
    echo "[*] Installing systemd service and timer..."
    cp "$SCRIPT_DIR"/security-monitor.service /etc/systemd/system/
    cp "$SCRIPT_DIR"/security-monitor.timer /etc/systemd/system/
    systemctl daemon-reload
    systemctl enable --now security-monitor.timer
    echo "[+] Systemd security monitoring timer enabled successfully!"
fi

echo "=== ✅ Installation Complete! ==="
echo "Commands available:"
echo "  - monitor"
echo "  - harden"
echo "  - remediate"
echo "  - incident"
echo "  - telemetry"
