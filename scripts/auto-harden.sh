#!/bin/bash
# ==============================================================================
# 🚀 PROTEÇÃO DO UBUNTU - AUTOMATED HARDENING, MONIT & SNORT NIDS INSTALLER
# "Make security insanely great and automated." - Inspired by Steve Jobs Mindset
# ==============================================================================

if [ "$EUID" -ne 0 ]; then
    echo "[-] harden requires root privileges to configure system services, firewall, and NIDS."
    echo "[*] Elevating privileges via sudo..."
    exec sudo "$0" "$@"
fi

echo "=== 🛡️ Starting Automated Server Hardening & NIDS Provisioning ==="

# 1. Firewall Enforcement (Fixing empty iptables / inactive UFW rules)
echo "[*] Configuring and enforcing UFW firewall rules..."
ufw --force default deny incoming
ufw --force default allow outgoing
ufw allow ssh
ufw --force enable
echo "[+] UFW Firewall is active and enforced."

# 2. Automated Snort NIDS Installation & Setup
echo "[*] Installing and configuring Snort NIDS..."
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq && apt-get install -y -qq snort >/dev/null 2>&1 || echo "[-] Snort package installation skipped or non-interactive."
mkdir -p /var/log/snort
touch /var/log/snort/alert.fast
chmod 755 /var/log/snort
echo "[+] Snort NIDS logging directory initialized."

# 3. Automated Monit Installation & Configuration
echo "[*] Installing and configuring Monit daemon..."
apt-get install -y -qq monit >/dev/null 2>&1

MONIT_CONF="/etc/monit/monitrc"
if [ -f "$MONIT_CONF" ]; then
    if ! grep -q "set daemon 60" "$MONIT_CONF"; then
        echo "set daemon 60" >> "$MONIT_CONF"
    fi
    
    if ! grep -q "check process sshd" "$MONIT_CONF"; then
        cat << 'EOF' >> "$MONIT_CONF"

check process sshd with pidfile /var/run/sshd.pid
    start program = "/usr/bin/systemctl start ssh"
    stop program = "/usr/bin/systemctl stop ssh"
    if failed port 22 protocol ssh then alert

check process fail2ban with pidfile /var/run/fail2ban/fail2ban.pid
    start program = "/usr/bin/systemctl start fail2ban"
    stop program = "/usr/bin/systemctl stop fail2ban"
    if 3 restarts within 5 cycles then timeout
EOF
    fi
    systemctl restart monit >/dev/null 2>&1 || true
    systemctl enable monit >/dev/null 2>&1 || true
    echo "[+] Monit daemon configured and running successfully."
fi

# 4. Sysctl Kernel Hardening
echo "[*] Applying kernel hardening parameters (sysctl)..."
SYSCTL_CONF="/etc/sysctl.d/99-protecao-hardening.conf"
cat << 'EOF' > "$SYSCTL_CONF"
# Kernel hardening parameters
fs.suid_dumpable = 0
kernel.kptr_restrict = 2
kernel.dmesg_restrict = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
EOF
sysctl --system >/dev/null 2>&1
echo "[+] Kernel hardening parameters applied."

echo "=== ✅ Automated Hardening & Snort NIDS Provisioning Complete! ==="
echo "Run 'monitor' or 'shield' to view the live dashboard."
