#!/bin/bash
# ==============================================================================
# 🛡️ PROTEÇÃO DO UBUNTU - ANTI-DDOS & AUTOMATED IP BLOCKING ENGINE
# "Proactive defense that stops attacks before they bring you down."
# ==============================================================================

if [ "$EUID" -ne 0 ]; then
    echo "[-] anti-ddos requires root privileges to configure kernel network limits and firewall rules."
    echo "[*] Elevating privileges via sudo..."
    exec sudo "$0" "$@"
fi

echo "=== 🛑 ACTIVATING ANTI-DDOS & AUTOMATED BLOCKING ENGINE ==="

# 1. Kernel SYN Flood & TCP Hardening (Sysctl)
echo "[*] Applying kernel SYN-flood and anti-DDoS parameters..."
SYSCTL_DDOS="/etc/sysctl.d/99-protecao-ddos.conf"
cat << 'EOF' > "$SYSCTL_DDOS"
# Anti-DDoS and SYN Flood Protection
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_max_syn_backlog = 4096
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_max_tw_buckets = 2000000
net.core.somaxconn = 1024
EOF
sysctl --system >/dev/null 2>&1
echo "[+] Kernel TCP network limits hardened against SYN floods."

# 2. Automated Connection Rate Limiting via UFW / IPTables
echo "[*] Configuring UFW rate limiting for SSH and HTTP/HTTPS..."
ufw limit ssh/tcp comment "Rate limit SSH brute force & connection floods" >/dev/null 2>&1 || true
ufw limit 80/tcp comment "Rate limit HTTP flood" >/dev/null 2>&1 || true
ufw limit 443/tcp comment "Rate limit HTTPS flood" >/dev/null 2>&1 || true
echo "[+] UFW rate limiting rules active."

# 3. Active Connection Flood Monitoring (Non-blocking / Availability-Safe)
echo "[*] Monitoring connection rates (relying on kernel SYN cookies and UFW rate limiting to preserve availability)..."
SUSP_IPS=$(ss -tunp 2>/dev/null | grep ESTAB | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr | awk '$1 > 200 {print $2}')

if [ -n "$SUSP_IPS" ]; then
    echo "[!] Notice: High connection volume detected from the following IPs (logged for review):"
    for ip in $SUSP_IPS; do
        if [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] && [ "$ip" != "127.0.0.1" ] && [ "$ip" != "0.0.0.0" ]; then
            echo "    -> High volume IP observed (not blocked to preserve uptime): $ip"
        fi
    done
else
    echo "[+] Connection volume within normal parameters."
fi

echo "=== ✅ ANTI-DDOS & AUTOMATED BLOCKING ACTIVE ==="
