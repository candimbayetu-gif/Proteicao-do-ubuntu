#!/bin/bash

echo "=== 🛡️ ADVANCED COMPETITION SECURITY MONITOR (v2.0) ==="
echo "Last updated: $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

# 1. SYSTEM HEALTH
echo "--- SYSTEM HEALTH ---"
echo "Load: $(uptime | awk -F'load average:' '{print $2}')"
MEM_USED=$(free -h | grep Mem | awk '{print $3}')
MEM_TOTAL=$(free -h | grep Mem | awk '{print $2}')
MEM_PERCENT=$(free | grep Mem | awk '{printf("%.0f"), $3/$2 * 100.0}')
echo "Memory: ${MEM_USED}/${MEM_TOTAL} (${MEM_PERCENT}%)"
DISK_USED=$(df -h / | awk 'NR==2 {print $5}')
echo "Disk Usage: $DISK_USED"

# 2. RECONNAISSANCE & ENUMERATION DETECTION
echo ""
echo "--- 🕵️ RECONNAISSANCE & ENUMERATION ALERTS ---"
# Check for common enumeration tools running in processes (LinPEAS, LinEnum, pspy, nmap)
ENUM_PROCS=$(ps aux | grep -iE '(linpeas|linenum|pspy|nmap|netcat|nc\.traditional|socat)' | grep -v grep)
if [ -n "$ENUM_PROCS" ]; then
    echo "🚨 ALERT: Suspicious Enumeration Tool Running!"
    echo "$ENUM_PROCS"
else
    echo "  No common enumeration tools detected in process list."
fi

# Check for SSH user enumeration attempts (Invalid users)
INVALID_USERS=$(sudo grep "Invalid user" /var/log/auth.log 2>/dev/null | grep "$(date '+%b %e %H:' --date='1 hour ago')" | wc -l)
echo "SSH Invalid User Attempts (last hour): $INVALID_USERS"

# 3. PRIVILEGE ESCALATION & SUDO MONITOR
echo ""
echo "--- 🚨 PRIVILEGE ESCALATION & SUDO MONITOR ---"
echo "Recent Sudo Activity:"
sudo grep "COMMAND=" /var/log/auth.log 2>/dev/null | tail -5 | awk -F': ' '{print $NF}'

echo "Users with Sudo Privileges:"
getent group sudo | cut -d: -f4

SUDOERS_PERM=$(sudo stat -c %a /etc/sudoers 2>/dev/null)
if [ "$SUDOERS_PERM" != "440" ] && [ "$SUDOERS_PERM" != "0440" ]; then
    echo "⚠️ ALERT: /etc/sudoers permissions are insecure ($SUDOERS_PERM)!"
fi

# 4. EXPLOITATION & ABNORMAL PROCESSES
echo ""
echo "--- 💥 EXPLOITATION & ABNORMAL SHELLS ---"
# Check if non-shell users (like www-data, nobody) have active running shells
SUSP_SHELLS=$(ps aux | grep -E '(www-data|nginx|apache|mysql|postgres|nobody)' | grep -E '(bash|sh|zsh|nc|python|perl)')
if [ -n "$SUSP_SHELLS" ]; then
    echo "🚨 ALERT: Service account running a shell (Possible RCE / Exploitation)!"
    echo "$SUSP_SHELLS"
else
    echo "  No suspicious service account shells detected."
fi

# 5. NETWORK & REVERSE SHELLS
echo ""
echo "--- NETWORK & CONNECTIONS ---"
echo "Listening Ports (Critical):"
sudo ss -tulpn 2>/dev/null | grep -E ':(22|80|443|53|21|23|25|3306|5432)' | grep LISTEN | head -10

echo "External Connections (Potential Reverse Shells):"
sudo ss -tunp 2>/dev/null | grep ESTABLISHED | grep -v 127.0.0.1 | grep -v :22 | head -5

# 6. FIREWALL & SERVICES
echo ""
echo "--- FIREWALL & SERVICES ---"
UFW_STATUS=$(sudo ufw status 2>/dev/null | grep "Status")
echo "Firewall: $UFW_STATUS"

for service in ssh ufw fail2ban; do
    if systemctl is-active --quiet $service 2>/dev/null; then
        echo "  $service: ACTIVE"
    else
        echo "  ❌ $service: INACTIVE"
    fi
done

# 7. PERSISTENCE & STAGING
echo ""
echo "--- 🔍 PERSISTENCE & STAGING ---"
TMP_FILES=$(find /tmp /dev/shm -type f 2>/dev/null | wc -l)
echo "Files in /tmp & /dev/shm: $TMP_FILES"
if [ "$TMP_FILES" -gt 0 ]; then
    find /tmp /dev/shm -type f 2>/dev/null | head -5
fi

echo ""
echo "=== MONITORING COMPLETE ==="
