#!/bin/bash
# ==============================================================================
# 🚀 PROTEÇÃO DO UBUNTU - ONE-CLICK SETUP & INSTALLER
# "One command. Total defense." - Steve Jobs Mindset
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
echo "[*] Installing clean commands to /usr/local/bin/..."
sudo cp scripts/security-monitor.sh /usr/local/bin/security-monitor
sudo cp scripts/auto-remediate.sh /usr/local/bin/auto-remediate
sudo cp scripts/incident-response.sh /usr/local/bin/incident-response
sudo cp scripts/export-telemetry.py /usr/local/bin/export-telemetry
sudo cp scripts/auto-harden.sh /usr/local/bin/auto-harden
sudo cp scripts/anti-ddos.sh /usr/local/bin/anti-ddos
sudo cp scripts/master-shield.sh /usr/local/bin/master-shield

sudo chmod +x /usr/local/bin/security-monitor
sudo chmod +x /usr/local/bin/auto-remediate
sudo chmod +x /usr/local/bin/incident-response
sudo chmod +x /usr/local/bin/export-telemetry
sudo chmod +x /usr/local/bin/auto-harden
sudo chmod +x /usr/local/bin/anti-ddos
sudo chmod +x /usr/local/bin/master-shield

# Create clean short symlinks
sudo ln -sf /usr/local/bin/security-monitor /usr/local/bin/monitor
sudo ln -sf /usr/local/bin/auto-remediate /usr/local/bin/remediate
sudo ln -sf /usr/local/bin/incident-response /usr/local/bin/incident
sudo ln -sf /usr/local/bin/export-telemetry /usr/local/bin/telemetry
sudo ln -sf /usr/local/bin/auto-harden /usr/local/bin/harden
sudo ln -sf /usr/local/bin/anti-ddos /usr/local/bin/block
sudo ln -sf /usr/local/bin/anti-ddos /usr/local/bin/antiddos
sudo ln -sf /usr/local/bin/master-shield /usr/local/bin/shield
sudo ln -sf /usr/local/bin/master-shield /usr/local/bin/defend
sudo ln -sf /usr/local/bin/master-shield /usr/local/bin/proteicao

echo ""
echo "=== ✅ INSTALLATION COMPLETE! ==="
echo "All-in-One Master Command:"
echo "  - shield (or defend, proteicao) -> Runs hardening, anti-DDoS, lockdown, and launches live monitor!"
echo ""
echo "Individual Commands:"
echo "  - monitor"
echo "  - harden"
echo "  - block"
echo "  - remediate"
echo "  - incident"
echo "  - telemetry"
echo ""
echo "Launching Master Shield now..."
echo "--------------------------------------------------"
shield
