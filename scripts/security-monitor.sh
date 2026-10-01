#!/bin/bash

# ==============================================================================
# 🛡️ ENTERPRISE SOC SECURITY MONITOR - LIVE DASHBOARD (v3.1)
# ==============================================================================

REFRESH_INTERVAL=20

cleanup() {
    echo -e "\n\n[+] Exiting Enterprise SOC Monitor. Stay secure!"
    exit 0
}

trap cleanup SIGINT SIGTERM

# Initial clear to clean screen once on start
clear

while true; do
    # Move cursor to top-left and clear from cursor down (prevents old ghosting/overlapping text)
    printf "\033[H\033[J"
    
    # Calculate Threat Metrics for Summary Banner
    ACTIVE_SESSIONS=$(who 2>/dev/null | wc -l)
    FAILED_COUNT=$(sudo grep -E "Failed password|Invalid user" /var/log/auth.log 2>/dev/null | wc -l)
    ENUM_COUNT=$(ps aux | grep -iE '(linpeas|linenum|pspy|nmap|netcat|nc\.traditional|socat|gobuster|dirb|hydra|sqlmap)' | grep -v grep | wc -l)
    SUSP_SHELL_COUNT=$(ps aux | grep -E '(www-data|nginx|apache|mysql|postgres|nobody)' | grep -E '(bash|sh|zsh|nc|python|perl|ruby)' | wc -l)
    
    # Professional Header Banner
    echo "┌──────────────────────────────────────────────────────────────────────────────┐"
    echo "│ 🛡️  ENTERPRISE SOC - UBUNTU THREAT DETECTION & MONITORING ENGINE (v3.1)     │"
    echo "│ Refresh: ${REFRESH_INTERVAL}s | Mode: Live Continuous | Press [Ctrl+C] to Exit             │"
    echo "│ Timestamp: $(date '+%Y-%m-%d %H:%M:%S')                                          │"
    echo "├──────────────────────────────────────────────────────────────────────────────┤"
    printf "│ Active Sessions: %-2s │ Failed Auth: %-3s │ Attack Tools: %-2s │ RCE Shells: %-2s │\n" "$ACTIVE_SESSIONS" "$FAILED_COUNT" "$ENUM_COUNT" "$SUSP_SHELL_COUNT"
    echo "└──────────────────────────────────────────────────────────────────────────────┘"

    # 1. SYSTEM HEALTH
    echo -e "\n\033[1;34m[+] SYSTEM HEALTH & PERFORMANCE\033[0m"
    LOAD=$(uptime | awk -F'load average:' '{print $2}')
    MEM_USED=$(free -h | grep Mem | awk '{print $3}')
    MEM_TOTAL=$(free -h | grep Mem | awk '{print $2}')
    MEM_PERCENT=$(free | grep Mem | awk '{printf("%.0f"), $3/$2 * 100.0}')
    DISK_USED=$(df -h / | awk 'NR==2 {print $5}')
    echo -e "  • Load Average : \033[1;33m$LOAD\033[0m"
    echo -e "  • Memory Usage : \033[1;33m${MEM_USED} / ${MEM_TOTAL} (${MEM_PERCENT}%)\033[0m"
    echo -e "  • Root Disk    : \033[1;33m$DISK_USED\033[0m"

    # 2. ACTIVE ACCESS SESSIONS
    echo -e "\n\033[1;34m[+] ACTIVE ACCESS SESSIONS (SSH / PuTTY / TTY)\033[0m"
    ACTIVE_USERS=$(who 2>/dev/null)
    if [ -n "$ACTIVE_USERS" ]; then
        echo "$ACTIVE_USERS" | awk '{print "  • User: " $1 " | Terminal: " $2 " | Login Time: " $3 " " $4 " | Host: " ($5 ? $5 : "local")}'
    else
        echo -e "  • \033[1;32mNo active terminal sessions detected.\033[0m"
    fi

    # 3. BRUTE-FORCE & AUTHENTICATION ATTACKS
    echo -e "\n\033[1;34m[+] BRUTE-FORCE & AUTHENTICATION MONITORING\033[0m"
    FAILED_LOGINS=$(sudo grep -E "Failed password|Invalid user" /var/log/auth.log 2>/dev/null | tail -3)
    if [ "$FAILED_COUNT" -gt 0 ]; then
        echo -e "  • \033[1;31mALERT: $FAILED_COUNT failed authentication / invalid user attempts logged!\033[0m"
        if [ -n "$FAILED_LOGINS" ]; then
            echo "$FAILED_LOGINS" | awk '{print "    -> " $1 " " $2 " " $3 " | " $(NF-3) " " $(NF-2) " " $(NF-1) " " $NF}'
        fi
    else
        echo -e "  • \033[1;32mNo failed authentication or brute-force signatures detected.\033[0m"
    fi

    # 4. RECONNAISSANCE & ATTACK TOOLS
    echo -e "\n\033[1;34m[+] RECONNAISSANCE & ENUMERATION TOOL DETECTION\033[0m"
    ENUM_PROCS=$(ps aux | grep -iE '(linpeas|linenum|pspy|nmap|netcat|nc\.traditional|socat|gobuster|dirb|hydra|sqlmap)' | grep -v grep)
    if [ -n "$ENUM_PROCS" ]; then
        echo -e "  • \033[1;31mCRITICAL ALERT: Suspicious attack/enumeration tool active!\033[0m"
        echo "$ENUM_PROCS" | awk '{print "    [PID: " $2 "] User: " $1 " | Command: " $11 " " $12}'
    else
        echo -e "  • \033[1;32mNo unauthorized enumeration or scanning tools found in process table.\033[0m"
    fi

    # 5. PRIVILEGE ESCALATION & SUDO MONITOR
    echo -e "\n\033[1;34m[+] PRIVILEGE ESCALATION & SUDO AUDIT\033[0m"
    SUDOERS_PERM=$(sudo stat -c %a /etc/sudoers 2>/dev/null)
    if [ "$SUDOERS_PERM" != "440" ] && [ "$SUDOERS_PERM" != "0440" ]; then
        echo -e "  • \033[1;31mWARNING: /etc/sudoers permissions are insecure ($SUDOERS_PERM)!\033[0m"
    else
        echo -e "  • \033[1;32m/etc/sudoers file permissions secure ($SUDOERS_PERM).\033[0m"
    fi
    RECENT_SUDO=$(sudo grep "COMMAND=" /var/log/auth.log 2>/dev/null | tail -2)
    if [ -n "$RECENT_SUDO" ]; then
        echo "  • Recent Sudo Execution:"
        echo "$RECENT_SUDO" | awk -F': ' '{print "    -> " $NF}'
    fi

    # 6. EXPLOITATION & RCE SHELLS
    echo -e "\n\033[1;34m[+] EXPLOITATION & SERVICE ACCOUNT SHELLS (RCE)\033[0m"
    SUSP_SHELLS=$(ps aux | grep -E '(www-data|nginx|apache|mysql|postgres|nobody)' | grep -E '(bash|sh|zsh|nc|python|perl|ruby)')
    if [ -n "$SUSP_SHELLS" ]; then
        echo -e "  • \033[1;31mCRITICAL ALERT: Service account running interactive shell!\033[0m"
        echo "$SUSP_SHELLS" | awk '{print "    [PID: " $2 "] User: " $1 " | Shell: " $11}'
    else
        echo -e "  • \033[1;32mNo service accounts running unauthorized interactive shells.\033[0m"
    fi

    # 7. NETWORK & REVERSE SHELLS
    echo -e "\n\033[1;34m[+] NETWORK, LISTENING PORTS & C2 CONNECTIONS\033[0m"
    echo "  • Critical Listening Services:"
    sudo ss -tulpn 2>/dev/null | grep LISTEN | head -5 | awk '{print "    -> Port: " $5 " | Service/App: " $7}'

    EXT_CONNS=$(sudo ss -tunp 2>/dev/null | grep ESTABLISHED | grep -v 127.0.0.1 | grep -v :22)
    if [ -n "$EXT_CONNS" ]; then
        echo -e "  • \033[1;33mWARNING: External established connections detected (Check for C2 / Reverse Shell):\033[0m"
        echo "$EXT_CONNS" | head -3 | awk '{print "    -> " $0}'
    else
        echo -e "  • \033[1;32mNo anomalous external connections detected.\033[0m"
    fi

    # 8. FIREWALL & DEFENSE SERVICES
    echo -e "\n\033[1;34m[+] FIREWALL & HARDENING SERVICES STATUS\033[0m"
    UFW_STATUS=$(sudo ufw status 2>/dev/null | grep "Status")
    echo -e "  • Firewall Status : \033[1;33m$UFW_STATUS\033[0m"
    for service in ssh ufw fail2ban; do
        if systemctl is-active --quiet $service 2>/dev/null; then
            echo -e "  • Service [$service] : \033[1;32mACTIVE\033[0m"
        else
            echo -e "  • Service [$service] : \033[1;31mINACTIVE\033[0m"
        fi
    done

    echo -e "\n────────────────────────────────────────────────────────────────────────────────"
    echo " ⏱️  Next automated refresh in ${REFRESH_INTERVAL} seconds... (Press Ctrl+C to quit)"
    echo "────────────────────────────────────────────────────────────────────────────────"

    sleep "$REFRESH_INTERVAL"
done
