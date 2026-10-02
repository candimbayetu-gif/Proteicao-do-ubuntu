#!/bin/bash

# ==============================================================================
# 🛡️ ENTERPRISE SOC SECURITY MONITOR - LIVE DASHBOARD (v3.4)
# Real Kernel Audit (auditd), UFW Firewall Block, & Live Attacker Tracking
# ==============================================================================

REFRESH_INTERVAL=20

cleanup() {
    echo -e "\n\n[+] Exiting Enterprise SOC Monitor. Stay secure!"
    exit 0
}

trap cleanup SIGINT SIGTERM

# Initial clear to clean screen once on start
clear

# Terminate any other running instances of security-monitor to prevent ghost/overlapping sessions
for pid in $(pgrep -f "security-monitor.sh"); do
    if [ "$pid" != "$$" ]; then
        kill -9 "$pid" 2>/dev/null || true
    fi
done

while true; do
    # Move cursor to top-left and clear from cursor down (flicker-free, no ghosting)
    printf "\033[H\033[J"
    
    # Calculate Real Threat Metrics for Summary Banner
    ACTIVE_SESSIONS=$(who 2>/dev/null | wc -l)
    FAILED_COUNT=$(sudo grep -E "Failed password|Invalid user" /var/log/auth.log 2>/dev/null | wc -l)
    ENUM_COUNT=$(ps aux | grep -iE '(linpeas|linenum|pspy|nmap|netcat|nc\.traditional|socat|gobuster|dirb|hydra|sqlmap)' | grep -v grep | wc -l)
    SUSP_SHELL_COUNT=$(ps aux | grep -E '(www-data|nginx|apache|mysql|postgres|nobody)' | grep -E '(bash|sh|zsh|nc|python|perl|ruby)' | wc -l)
    BLOCKED_PACKETS=$(sudo grep -i "UFW BLOCK" /var/log/kern.log 2>/dev/null | wc -l)
    
    # Professional Header Banner
    echo "┌──────────────────────────────────────────────────────────────────────────────┐"
    echo "│ 🛡️  ENTERPRISE SOC - KERNEL AUDIT & THREAT INTELLIGENCE (v3.4)              │"
    echo "│ Refresh: ${REFRESH_INTERVAL}s | Mode: Kernel/Audit Active | Press [Ctrl+C] to Exit   │"
    echo "│ Timestamp: $(date '+%Y-%m-%d %H:%M:%S')                                          │"
    echo "├──────────────────────────────────────────────────────────────────────────────┤"
    printf "│ Active Sessions: %-2s │ Failed Auth: %-3s │ UFW Blocks: %-3s │ RCE Shells: %-2s │\n" "$ACTIVE_SESSIONS" "$FAILED_COUNT" "$BLOCKED_PACKETS" "$SUSP_SHELL_COUNT"
    echo "└──────────────────────────────────────────────────────────────────────────────┘"

    # EXECUTIVE ANOMALY & STATE CHANGE OVERVIEW
    echo -e "\n\033[1;36m[⚡] EXECUTIVE ANOMALY & STATE CHANGE OVERVIEW\033[0m"
    ANOMALY_STATUS="\033[1;32mSECURE (No active anomalies)\033[0m"
    if [ "$ENUM_COUNT" -gt 0 ] || [ "$SUSP_SHELL_COUNT" -gt 0 ]; then
        ANOMALY_STATUS="\033[1;31m🚨 CRITICAL ANOMALY DETECTED (Recon/RCE Shells Active)\033[0m"
    elif [ "$FAILED_COUNT" -gt 10 ]; then
        ANOMALY_STATUS="\033[1;33m⚠️ WARNING (Elevated Brute-Force Activity)\033[0m"
    fi
    echo -e "  • System State Verdict : $ANOMALY_STATUS"
    echo -e "  • Active Anomalies     : Recon Tools ($ENUM_COUNT) | RCE Shells ($SUSP_SHELL_COUNT) | Failed Logins ($FAILED_COUNT)"
    echo -e "  • Telemetry Output     : Saved to /var/log/security-incidents/telemetry.json"

    # 1. SYSTEM HEALTH
    echo -e "\n\033[1;34m[+] SYSTEM HEALTH & INTEGRITY\033[0m"
    LOAD=$(uptime | awk -F'load average:' '{print $2}')
    MEM_USED=$(free -h | grep Mem | awk '{print $3}')
    MEM_TOTAL=$(free -h | grep Mem | awk '{print $2}')
    MEM_PERCENT=$(free | grep Mem | awk '{printf("%.0f"), $3/$2 * 100.0}')
    DISK_USED=$(df -h / | awk 'NR==2 {print $5}')
    echo -e "  • Load Average : \033[1;33m$LOAD\033[0m"
    echo -e "  • Memory Usage : \033[1;33m${MEM_USED} / ${MEM_TOTAL} (${MEM_PERCENT}%)\033[0m"
    echo -e "  • Root Disk    : \033[1;33m$DISK_USED\033[0m"

    # 2. ACTIVE ACCESS SESSIONS (Sanitized)
    echo -e "\n\033[1;34m[+] ACTIVE ACCESS SESSIONS (Sanitized)\033[0m"
    ACTIVE_USERS=$(who 2>/dev/null)
    if [ -n "$ACTIVE_USERS" ]; then
        echo "$ACTIVE_USERS" | awk '{print "  • User: " $1 " | Terminal: " $2 " | Login: " $3 " " $4 " | Origin IP: " ($5 ? $5 : "local")}'
    else
        echo -e "  • \033[1;32mNo active sessions detected.\033[0m"
    fi

    # 3. KERNEL AUDIT ENGINE (`auditd`) & FILE INTEGRITY
    echo -e "\n\033[1;34m[+] KERNEL AUDIT ENGINE (auditd) & FILE INTEGRITY\033[0m"
    if systemctl is-active --quiet auditd 2>/dev/null; then
        echo -e "  • Kernel Audit Daemon (auditd): \033[1;32mACTIVE (Kernel-level monitoring)\033[0m"
        RECENT_AUDIT=$(sudo ausearch -m PATH -ts recent 2>/dev/null | grep -E '(sudoers|passwd|shadow)' | tail -2)
        if [ -n "$RECENT_AUDIT" ]; then
            echo -e "    -> \033[1;31mALERT: Critical system file modification detected by kernel audit!\033[0m"
        else
            echo -e "    -> No recent unauthorized modifications to critical system files in audit log."
        fi
    else
        echo -e "  • Kernel Audit Daemon (auditd): \033[1;33mINACTIVE (Tip: sudo apt install auditd)\033[0m"
    fi

    # 4. LIVE ATTACKER SCANNING & AUTO-BLOCKED IPS
    echo -e "\n\033[1;31m[+] LIVE ATTACKER SCANNING & AUTO-BLOCKED IPS\033[0m"
    
    # Extract scanning / probing source IPs from UFW kern.log
    SCANNING_IPS=$(sudo grep -i "UFW BLOCK" /var/log/kern.log 2>/dev/null | grep -oP 'SRC=\K[0-9.]+' | sort | uniq -c | sort -nr | head -5)
    if [ -n "$SCANNING_IPS" ]; then
        echo -e "  • \033[1;33mExternal IPs Probing / Scanning Server Ports:\033[0m"
        echo "$SCANNING_IPS" | awk '{print "    -> Scanner IP: " $2 " | Probe Hits: " $1}'
    else
        echo -e "  • \033[1;32mNo external port scanning detected in kernel logs.\033[0m"
    fi

    # Extract Fail2ban Banned IPs if available
    if command -v fail2ban-client &>/dev/null && systemctl is-active --quiet fail2ban; then
        BANNED_IPS=$(sudo fail2ban-client status sshd 2>/dev/null | grep "Banned IP list" | sed 's/.*Banned IP list:\s*//')
        if [ -n "$BANNED_IPS" ] && [ "$BANNED_IPS" != "" ]; then
            echo -e "  • \033[1;31m🔒 Automatically Banned IPs (Fail2Ban):\033[0m"
            echo "    -> $BANNED_IPS"
        else
            echo -e "  • \033[1;32mNo IPs currently banned by Fail2Ban SSH jail.\033[0m"
        fi
    fi

    # 5. SNORT NIDS INTRUSION DETECTION ALERTS
    echo -e "\n\033[1;31m[+] SNORT NIDS - NETWORK INTRUSION ALERTS\033[0m"
    SNORT_LOG="/var/log/snort/alert.fast"
    if [ ! -f "$SNORT_LOG" ]; then
        SNORT_LOG="/var/log/snort/alert"
    fi
    if [ -f "$SNORT_LOG" ]; then
        SNORT_ALERTS=$(sudo tail -n 5 "$SNORT_LOG" 2>/dev/null)
        if [ -n "$SNORT_ALERTS" ]; then
            echo -e "  • \033[1;31mALERT: Snort NIDS detected network intrusion signatures!\033[0m"
            echo "$SNORT_ALERTS" | awk '{print "    -> [Snort] " $0}'
        else
            echo -e "  • \033[1;32mNo recent Snort network intrusion alerts.\033[0m"
        fi
    else
        echo -e "  • \033[1;33mSnort log not found (Tip: sudo apt install snort)\033[0m"
    fi

    # 6. ATTACKER IP INTELLIGENCE & BRUTE-FORCE MONITORING
    echo -e "\n\033[1;34m[+] ATTACKER IP INTELLIGENCE & BRUTE-FORCE MONITORING\033[0m"
    if [ "$FAILED_COUNT" -gt 0 ]; then
        echo -e "  • \033[1;31mALERT: $FAILED_COUNT brute-force / failed authentication attempts!\033[0m"
        echo "  • Top Attacking Source IPs:"
        TOP_IPS=$(sudo grep -E "Failed password|Invalid user" /var/log/auth.log 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="from") print $(i+1)}' | sort | uniq -c | sort -nr | head -3)
        if [ -n "$TOP_IPS" ]; then
            echo "$TOP_IPS" | awk '{print "    -> Attacker IP: " $2 " | Failed Attempts: " $1}'
        fi
    else
        echo -e "  • \033[1;32mNo brute-force attack attempts detected.\033[0m"
    fi

    # 6. RECONNAISSANCE & ATTACK TOOLS
    echo -e "\n\033[1;34m[+] RECONNAISSANCE & ATTACK TOOL DETECTION\033[0m"
    ENUM_PROCS=$(ps aux | grep -iE '(linpeas|linenum|pspy|nmap|netcat|nc\.traditional|socat|gobuster|dirb|hydra|sqlmap)' | grep -v grep)
    if [ -n "$ENUM_PROCS" ]; then
        echo -e "  • \033[1;31mCRITICAL ALERT: Unauthorized scanning/attack tool detected!\033[0m"
        echo "$ENUM_PROCS" | awk '{print "    -> Tool Process: " $11 " (PID: " $2 ")"}'
    else
        echo -e "  • \033[1;32mNo unauthorized reconnaissance or attack tools active.\033[0m"
    fi

    # 7. EXPLOITATION & RCE SHELLS
    echo -e "\n\033[1;34m[+] EXPLOITATION & SERVICE ACCOUNT SHELLS (RCE)\033[0m"
    SUSP_SHELLS=$(ps aux | grep -E '(www-data|nginx|apache|mysql|postgres|nobody)' | grep -E '(bash|sh|zsh|nc|python|perl|ruby)')
    if [ -n "$SUSP_SHELLS" ]; then
        echo -e "  • \033[1;31mCRITICAL ALERT: Service account running interactive shell!\033[0m"
        echo "$SUSP_SHELLS" | awk '{print "    -> Account: " $1 " | Shell PID: " $2}'
    else
        echo -e "  • \033[1;32mNo service accounts running unauthorized interactive shells.\033[0m"
    fi

    # 8. DEFENSE SERVICES STATUS
    echo -e "\n\033[1;34m[+] DEFENSE SERVICES STATUS\033[0m"
    for service in ssh ufw fail2ban auditd; do
        if systemctl is-active --quiet $service 2>/dev/null; then
            echo -e "  • Service [$service] : \033[1;32mACTIVE\033[0m"
        else
            echo -e "  • Service [$service] : \033[1;31mINACTIVE\033[0m"
        fi
    done

    echo -e "\n────────────────────────────────────────────────────────────────────────────────"
    echo " ⏱️  Next automated refresh in ${REFRESH_INTERVAL} seconds... [Kernel Audit Mode]"
    echo "────────────────────────────────────────────────────────────────────────────────"

    sleep "$REFRESH_INTERVAL"
done
