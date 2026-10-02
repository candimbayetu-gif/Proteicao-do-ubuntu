#!/bin/bash
# ==============================================================================
# 🚀 PROTEÇÃO DO UBUNTU - ONE-CLICK SETUP & INSTALLER
# "Simplicity is the ultimate sophistication." - Steve Jobs Mindset
# ==============================================================================

set -e

REPO_URL="https://github.com/candimbayetu-gif/Proteicao-do-ubuntu.git"
INSTALL_DIR="$HOME/Proteicao-do-ubuntu"

echo "=== 🛡️ SETTING UP PROTEÇÃO DO UBUNTU ==="

# 1. Clone or update repository
if [ -d "$INSTALL_DIR" ]; then
    echo "[*] Updating existing repository..."
    cd "$INSTALL_DIR"
    git pull origin main
else
    echo "[*] Cloning repository from GitHub..."
    git clone "$REPO_URL" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

# 2. Make scripts executable and install symlinks without prefixes
echo "[*] Installing clean, prefix-free commands to /usr/local/bin/..."
sudo cp scripts/security-monitor.sh /usr/local/bin/security-monitor
sudo cp scripts/auto-remediate.sh /usr/local/bin/auto-remediate
sudo cp scripts/incident-response.sh /usr/local/bin/incident-response
sudo cp scripts/export-telemetry.py /usr/local/bin/export-telemetry
sudo cp scripts/auto-harden.sh /usr/local/bin/auto-harden

sudo chmod +x /usr/local/bin/security-monitor
sudo chmod +x /usr/local/bin/auto-remediate
sudo chmod +x /usr/local/bin/incident-response
sudo chmod +x /usr/local/bin/export-telemetry
sudo chmod +x /usr/local/bin/auto-harden

# Create clean short symlinks (monitor, remediate, incident, telemetry, harden)
sudo ln -sf /usr/local/bin/security-monitor /usr/local/bin/monitor
sudo ln -sf /usr/local/bin/auto-remediate /usr/local/bin/remediate
sudo ln -sf /usr/local/bin/incident-response /usr/local/bin/incident
sudo ln -sf /usr/local/bin/export-telemetry /usr/local/bin/telemetry
sudo ln -sf /usr/local/bin/auto-harden /usr/local/bin/harden

echo ""
echo "=== ✅ INSTALLATION COMPLETE! ==="
echo "You can now run your tools cleanly from anywhere:"
echo "  - monitor      (Run real-time SOC security monitor)"
echo "  - harden       (Automate Monit, UFW firewall & kernel hardening)"
echo "  - remediate    (Run automated remediation/lockdown)"
echo "  - incident     (Generate forensic incident report)"
echo "  - telemetry    (Export structured JSON telemetry for SIEM)"
echo ""
echo "Running security monitor now for the first time..."
echo "--------------------------------------------------"
monitor
