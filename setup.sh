#!/bin/bash
# ==============================================================================
# 🚀 PROTEÇÃO DO UBUNTU - ONE-CLICK SETUP & INSTALLER
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

# 2. Make scripts executable and install to system PATH
echo "[*] Installing scripts to /usr/local/bin/..."
sudo cp scripts/*.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/*.sh

# Rename without .sh for easier CLI usage (optional convenience)
sudo ln -sf /usr/local/bin/security-monitor.sh /usr/local/bin/sec-monitor
sudo ln -sf /usr/local/bin/auto-remediate.sh /usr/local/bin/sec-remediate
sudo ln -sf /usr/local/bin/incident-response.sh /usr/local/bin/sec-incident

echo ""
echo "=== ✅ INSTALLATION COMPLETE! ==="
echo "You can now run your tools from anywhere using:"
echo "  - sec-monitor    (Run real-time security monitor)"
echo "  - sec-remediate  (Run automated remediation/lockdown)"
echo "  - sec-incident   (Generate forensic incident report)"
echo ""
echo "Running security monitor now for the first time..."
echo "--------------------------------------------------"
sec-monitor
