#!/bin/bash
# ==============================================================================
# ⚡ AUTOMATED REMEDIATION & HARDENING SCRIPT
# ==============================================================================

echo "=== ⚡ RUNNING AUTOMATED REMEDIATION ==="

# 1. Fix Sudoers Permissions
echo "[*] Hardening /etc/sudoers permissions..."
sudo chown root:root /etc/sudoers
sudo chmod 440 /etc/sudoers

# 2. Ensure UFW Firewall is Active & Enforced
echo "[*] Ensuring UFW Firewall is active..."
sudo ufw --force enable

# 3. Kill Suspicious Service Account Shells (RCE Remediation)
echo "[*] Checking for service accounts running shells..."
for user in www-data nginx apache postgres nobody; do
    PIDS=$(ps -u "$user" -o pid= 2>/dev/null)
    if [ -n "$PIDS" ]; then
        echo "⚠️ Killing active processes for restricted user: $user"
        sudo pkill -u "$user"
    fi
    # Ensure service user shell is nologin
    sudo usermod -s /usr/sbin/nologin "$user" 2>/dev/null
done

# 4. Enforce SSH Security Settings
echo "[*] Enforcing SSH security configuration..."
sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart ssh

echo "=== ✅ REMEDIATION COMPLETED ==="
