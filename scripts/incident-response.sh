#!/bin/bash
# ==============================================================================
# 🛡️ INCIDENT RESPONSE & FORENSIC SNAPSHOT TOOL
# ==============================================================================

REPORT_DIR="/var/log/security-incidents"
mkdir -p "$REPORT_DIR"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
REPORT_FILE="$REPORT_DIR/incident_report_$TIMESTAMP.txt"

echo "=== 🕵️ INCIDENT RESPONSE FORENSIC SNAPSHOT ===" | tee "$REPORT_FILE"
echo "Generated at: $(date)" | tee -a "$REPORT_FILE"
echo "==================================================" | tee -a "$REPORT_FILE"

# 1. Active Connections & Reverse Shells
echo -e "\n[+] ACTIVE NETWORK CONNECTIONS:" | tee -a "$REPORT_FILE"
ss -tunp 2>/dev/null | tee -a "$REPORT_FILE"

# 2. Running Processes & Suspicious Shells
echo -e "\n[+] RUNNING PROCESSES (Service Shells & Enumeration):" | tee -a "$REPORT_FILE"
ps aux | grep -E '(www-data|nginx|apache|postgres|nobody|linpeas|pspy|nmap)' | tee -a "$REPORT_FILE"

# 3. Recent Authentication & Sudo Activity
echo -e "\n[+] RECENT AUTHENTICATION & SUDO LOGS:" | tee -a "$REPORT_FILE"
tail -n 30 /var/log/auth.log 2>/dev/null | grep -E "Accepted|Failed|COMMAND|sudo" | tee -a "$REPORT_FILE"

# 4. Modified or New SUID Binaries (Privilege Escalation Artifacts)
echo -e "\n[+] SUID BINARIES CHECK:" | tee -a "$REPORT_FILE"
find / -perm -4000 -type f 2>/dev/null | tee -a "$REPORT_FILE"

# 5. Cron Jobs & Persistence
echo -e "\n[+] CRON JOBS & PERSISTENCE ARTIFACTS:" | tee -a "$REPORT_FILE"
ls -la /etc/cron* /var/spool/cron/crontabs/ 2>/dev/null | tee -a "$REPORT_FILE"

echo -e "\n==================================================" | tee -a "$REPORT_FILE"
echo "Forensic snapshot saved to: $REPORT_FILE"
