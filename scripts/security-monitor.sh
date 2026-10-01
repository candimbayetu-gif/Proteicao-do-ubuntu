#!/bin/bash

# ==============================================================================
# 🛡️ ADVANCED COMPETITION SECURITY MONITOR - LIVE SOC DASHBOARD (v2.1)
# ==============================================================================

REFRESH_INTERVAL=5

cleanup() {
    echo -e "\n\n[+] Exiting SOC Live Monitor. Stay secure!"
    exit 0
}

trap cleanup SIGINT SIGTERM

while true; do
    clear
    
    # SOC Header
    echo "================================================================================"
    echo " 🛡️  PROTEÇÃO DO UBUNTU - LIVE SOC MONITOR & THREAT DETECTION"
    echo " Refresh Interval: ${REFRESH_INTERVAL}s | Press Ctrl+C to Exit"
    echo " Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "================================================================================"

    # 1. SYSTEM HEALTH
    echo -e "\n\033[1;36m--- 🖥️ SYSTEM HEALTH ---"
    LOAD=$(uptime | awk -F'load average:' '{print $2}')
    MEM_USED=$(free -h | grep Mem | awk '{print $3}')
    MEM_TOTAL=$(free -h | grep Mem | awk '{print $2}')
    MEM_PERCENT=$(free | grep Mem | awk '{printf("%.0f"), $3/$2 * 100.0}')
    DISK_USED=$(df -h / | awk 'NR==2 {print $5}')
    echo -e " Load Average: \033[1;33m$LOAD\033[0m"
    echo -e " Memory Usage: \033[1;33m${MEM_USED}/${MEM_TOTAL} (${MEM_PERCENT}%)\033[0m"
    echo -e " Root Disk Usage: \033[1;33m$DISK_USED\033[0m"

    # 2. RECONNAISSANCE & ENUMERATION DETECTION
    echo -e "\n\033[1;36m--- 🕵️ RECONNAISSANCE & ENUMERATION ALERTS ---"
    ENUM_PROCS=$(ps aux | grep -iE '(linpeas|linenum|pspy|nmap|netcat|nc\.traditional|socat)' | grep -v grep)
    if [ -n "$ENUM_PROCS" ]; then
        echo -e " \033[1;31m🚨 ALERT: Suspicious Enumeration Tool Running!\033[0m"
        echo "$ENUM_PROCS"
    else
        echo -e " \033[1;32m✓ No common enumeration tools detected in process list.\033[0m"
    fi

    INVALID_USERS=$(sudo grep "Invalid user" /var/log/auth.log 2>/dev/null | grep "$(date '+%b %e %H:' --date='1 hour ago')" | wc -l)
    echo -e " SSH Invalid User Attempts (last hour): \033[1;33m$INVALID_USERS\033[0m"

    # 3. PRIVILEGE ESCALATION & SUDO MONITOR
    echo -e "\n\033[1;36m--- 🚨 PRIVILEGE ESCALATION & SUDO MONITOR ---"
    echo "Recent Sudo Activity:"
    sudo grep "COMMAND=" /var/log/auth.log 2>/dev/null | tail -3 | awk -F': ' '{print "   " $NF}'

    SUDOERS_PERM=$(sudo stat -c %a /etc/sudoers 2>/dev/null)
    if [ "$SUDOERS_PERM" != "440" ] && [ "$SUDOERS_PERM" != "0440" ]; then
        echo -e " \033[1;31m⚠️ ALERT: /etc/sudoers permissions are insecure ($SUDOERS_PERM)!\033[0m"
    else
        echo -e " \033[1;32m✓ /etc/sudoers permissions secure ($SUDOERS_PERM).\033[0m"
    fi

    # 4. EXPLOITATION & ABNORMAL PROCESSES
    echo -e "\n\033[1;36m--- 💥 EXPLOITATION & ABNORMAL SHELLS ---"
    SUSP_SHELLS=$(ps aux | grep -E '(www-data|nginx|apache|mysql|postgres|nobody)' | grep -E '(bash|sh|zsh|nc|python|perl)')
    if [ -n "$SUSP_SHELLS" ]; then
        echo -e " \033[1;31m🚨 ALERT: Service account running a shell (Possible RCE)!\033[0m"
        echo "$SUSP_SHELLS"
    else
        echo -e " \033[1;32m✓ No suspicious service account shells detected.\033[0m"
    fi

    # 5. NETWORK & REVERSE SHELLS
    echo -e "\n\033[1;36m--- 🌐 NETWORK & CONNECTIONS ---"
    echo "Listening Ports (Critical):"
    sudo ss -tulpn 2>/dev/null | grep -E ':(22|80|443|53|21|23|25|3306|5432)' | grep LISTEN | head -6 | awk '{print "   " $0}'

    EXT_CONNS=$(sudo ss -tunp 2>/dev/null | grep ESTABLISHED | grep -v 127.0.0.1 | grep -v :22)
    if [ -n "$EXT_CONNS" ]; then
        echo -e " \033[1;33m⚠️ External Established Connections (Check for Reverse Shells):\033[0m"
        echo "$EXT_CONNS" | head -5 | awk '{print "   " $0}'
    else
        echo -e " \033[1;32m✓ No suspicious external established connections.\033[0m"
    fi

    # 6. FIREWALL & SERVICES
    echo -e "\n\033[1;36m--- 🔥 FIREWALL & SERVICES ---"
    UFW_STATUS=$(sudo ufw status 2>/dev/null | grep "Status")
    echo -e " Firewall: \033[1;33m$UFW_STATUS\033[0m"

    for service in ssh ufw fail2ban; do
        if systemctl is-active --quiet $service 2>/dev/null; then
            echo -e "   $service: \033[1;32mACTIVE\033[0m"
        else
            echo -e "   $service: \033[1;31mINACTIVE\033[0m"
        fi
    done

    # 7. PERSISTENCE & STAGING
    echo -e "\n\033[1;36m--- 🔍 PERSISTENCE & STAGING ---"
    TMP_FILES=$(find /tmp /dev/shm -type f 2>/dev/null | wc -l)
    echo -e " Files in /tmp & /dev/shm: \033[1;33m$TMP_FILES\033[0m"
    if [ "$TMP_FILES" -gt 0 ]; then
        find /tmp /dev/shm -type f 2>/dev/null | head -3 | awk '{print "   " $0}'
    fi

    echo -e "\n================================================================================"
    echo " Next refresh in ${REFRESH_INTERVAL} seconds... (Press Ctrl+C to quit)"
    echo "================================================================================"

    sleep "$REFRESH_INTERVAL"
done
