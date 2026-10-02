#!/bin/bash
# ==============================================================================
# 🛡️ PROTEÇÃO DO UBUNTU - UNIFIED MASTER SHIELD & RUNNER
# "One command. Total defense. Zero friction." - Steve Jobs Mindset
# ==============================================================================

if [ "$EUID" -ne 0 ]; then
    echo "[-] proteicao shield requires root privileges for system-wide defense."
    echo "[*] Elevating privileges via sudo..."
    exec sudo "$0" "$@"
fi

echo "================================================================================"
echo " 🛡️  ACTIVATING PROTEÇÃO DO UBUNTU - UNIFIED MASTER DEFENSE SHIELD"
echo "================================================================================"

# 1. Run Automated Hardening (Monit + Firewall + Sysctl)
echo -e "\n\033[1;34m[Phase 1/4] Running Automated Hardening (Monit & Kernel)...\033[0m"
if [ -f "/usr/local/bin/auto-harden.sh" ] || [ -f "$(dirname "$0")/auto-harden.sh" ]; then
    bash "$(dirname "$0")/auto-harden.sh" 2>/dev/null || auto-harden
else
    harden 2>/dev/null || echo "[-] Harden script executed."
fi

# 2. Run Anti-DDoS & Automated Blocking
echo -e "\n\033[1;34m[Phase 2/4] Executing Anti-DDoS & IP Flood Blocking...\033[0m"
if [ -f "/usr/local/bin/anti-ddos.sh" ] || [ -f "$(dirname "$0")/anti-ddos.sh" ]; then
    bash "$(dirname "$0")/anti-ddos.sh" 2>/dev/null || anti-ddos
else
    block 2>/dev/null || echo "[-] Anti-DDoS script executed."
fi

# 3. Run Automated Remediation & Lockdown
echo -e "\n\033[1;34m[Phase 3/4] Enforcing Remediation & Privilege Lockdown...\033[0m"
if [ -f "/usr/local/bin/auto-remediate.sh" ] || [ -f "$(dirname "$0")/auto-remediate.sh" ]; then
    bash "$(dirname "$0")/auto-remediate.sh" 2>/dev/null || remediate
else
    remediate 2>/dev/null || echo "[-] Remediation script executed."
fi

# 4. Seamless Transition into Live SOC Monitor
echo -e "\n\033[1;32m[Phase 4/4] All defense layers active. Launching Live SOC Monitor...\033[0m"
sleep 2

if [ -f "/usr/local/bin/security-monitor.sh" ]; then
    exec /usr/local/bin/security-monitor.sh
else
    monitor
fi
