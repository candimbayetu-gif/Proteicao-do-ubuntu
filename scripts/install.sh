#!/bin/bash
# ==============================================================================
# 🛡️ Proteção do Ubuntu - Installer Script
# ==============================================================================

set -e

echo "=== Installing Proteção do Ubuntu Toolkit ==="

# 1. Copy scripts to /usr/local/bin
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "[*] Installing scripts to /usr/local/bin..."
cp "$SCRIPT_DIR"/security-monitor.sh /usr/local/bin/sec-monitor
cp "$SCRIPT_DIR"/auto-remediate.sh /usr/local/bin/sec-remediate
cp "$SCRIPT_DIR"/incident-response.sh /usr/local/bin/sec-incident
cp "$SCRIPT_DIR"/export-telemetry.py /usr/local/bin/sec-telemetry
chmod +x /usr/local/bin/sec-monitor
chmod +x /usr/local/bin/sec-remediate
chmod +x /usr/local/bin/sec-incident
chmod +x /usr/local/bin/sec-telemetry

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
echo "  - security-monitor.sh"
echo "  - auto-remediate.sh"
echo "  - incident-response.sh"
