#!/bin/bash
# ==============================================================================
# 🛡️ PROTEÇÃO DO UBUNTU - UNIFIED MASTER SHIELD & RUNNER
# "One command. Total defense. Zero friction." - Steve Jobs Mindset
# ==============================================================================

if [ "$EUID" -ne 0 ]; then
    echo "[-] shield requires root privileges for system-wide defense."
    echo "[*] Elevating privileges via sudo..."
    exec sudo "$0" "$@"
fi

echo "================================================================================"
echo " 🛡️  ACTIVATING PROTEÇÃO DO UBUNTU - UNIFIED MASTER DEFENSE SHIELD"
echo "================================================================================"

# Sync latest scripts from repository if run from repo directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/security-monitor.sh" ]; then
    echo "[*] Syncing latest toolkit scripts to /usr/local/bin..."
    cp "$SCRIPT_DIR"/security-monitor.sh /usr/local/bin/security-monitor
    cp "$SCRIPT_DIR"/auto-remediate.sh /usr/local/bin/auto-remediate
    cp "$SCRIPT_DIR"/incident-response.sh /usr/local/bin/incident-response
    cp "$SCRIPT_DIR"/export-telemetry.py /usr/local/bin/export-telemetry
    cp "$SCRIPT_DIR"/auto-harden.sh /usr/local/bin/auto-harden
    cp "$SCRIPT_DIR"/anti-ddos.sh /usr/local/bin/anti-ddos
    cp "$SCRIPT_DIR"/master-shield.sh /usr/local/bin/master-shield
    cp "$SCRIPT_DIR"/honeypot.sh /usr/local/bin/honeypot

    chmod +x /usr/local/bin/security-monitor
    chmod +x /usr/local/bin/auto-remediate
    chmod +x /usr/local/bin/incident-response
    chmod +x /usr/local/bin/export-telemetry
    chmod +x /usr/local/bin/auto-harden
    chmod +x /usr/local/bin/anti-ddos
    chmod +x /usr/local/bin/master-shield
    chmod +x /usr/local/bin/honeypot

    ln -sf /usr/local/bin/security-monitor /usr/local/bin/monitor
    ln -sf /usr/local/bin/auto-remediate /usr/local/bin/remediate
    ln -sf /usr/local/bin/incident-response /usr/local/bin/incident
    ln -sf /usr/local/bin/export-telemetry /usr/local/bin/telemetry
    ln -sf /usr/local/bin/auto-harden /usr/local/bin/harden
    ln -sf /usr/local/bin/anti-ddos /usr/local/bin/block
    ln -sf /usr/local/bin/anti-ddos /usr/local/bin/antiddos
    ln -sf /usr/local/bin/master-shield /usr/local/bin/shield
    ln -sf /usr/local/bin/master-shield /usr/local/bin/defend
    ln -sf /usr/local/bin/master-shield /usr/local/bin/proteicao
    ln -sf /usr/local/bin/honeypot /usr/local/bin/pot
fi

# 1. Run Automated Hardening (Monit + Snort + Firewall + Sysctl)
echo -e "\n\033[1;34m[Phase 1/5] Running Automated Hardening (Monit, Snort & Kernel)...\033[0m"
auto-harden 2>/dev/null || bash "$SCRIPT_DIR/auto-harden.sh"

# 2. Run Anti-DDoS & Automated Blocking
echo -e "\n\033[1;34m[Phase 2/5] Executing Anti-DDoS & IP Flood Rate-Limiting...\033[0m"
block 2>/dev/null || bash "$SCRIPT_DIR/anti-ddos.sh"

# 3. Run Automated Remediation & Lockdown
echo -e "\n\033[1;34m[Phase 3/5] Enforcing Remediation & Privilege Lockdown...\033[0m"
remediate 2>/dev/null || bash "$SCRIPT_DIR/auto-remediate.sh"

# 4. Activate Decoy Honeypot Trap
echo -e "\n\033[1;34m[Phase 4/5] Activating Decoy Honeypot Trap (Ports 2222, 8080)...\033[0m"
honeypot 2>/dev/null || bash "$SCRIPT_DIR/honeypot.sh"

# 5. Seamless Transition into Live SOC Monitor
echo -e "\n\033[1;32m[Phase 5/5] All defense layers active. Launching Live SOC Monitor...\033[0m"
sleep 2

exec security-monitor
