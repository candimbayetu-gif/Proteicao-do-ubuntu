# 🛡️ Proteção do Ubuntu (Competition & Security Edition v2.1)

A lightweight, practical toolkit of scripts, detection monitors, automated remediation, systemd automation, and forensic tools for hardening, securing, and monitoring Ubuntu servers.

---

## 📂 Repository Structure

* `scripts/security-monitor.sh`: Real-time monitoring script for system health, privilege escalation, sudo activity, reconnaissance, and reverse shells.
* `scripts/auto-remediate.sh`: Automated remediation script to lock down permissions, enforce firewall, kill malicious service shells, and secure SSH.
* `scripts/incident-response.sh`: Forensic snapshot tool that dumps active connections, process trees, SUID binaries, and auth logs into timestamped reports for post-incident analysis.
* `scripts/install.sh`: Automated installer script that sets up global commands and configures systemd timers.
* `scripts/security-monitor.service` & `scripts/security-monitor.timer`: Systemd background automation for periodic security audits.
* `docs/security-checklist.md`: Essential security and hardening checklist for Ubuntu systems.
* `docs/monitoring-guide.md`: Quick reference for real-time monitoring.

---

## 🚀 Quick Installation & Deployment

### 1. Run Automated Installer
```bash
sudo ./scripts/install.sh
```

### 2. Manual Installation (Alternative)
```bash
sudo cp scripts/*.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/*.sh
sudo mkdir -p /var/log/security-incidents
```

### 3. Run the Security Monitor
```bash
# Run once
security-monitor.sh

# Run continuously every 10 seconds
watch -n 10 security-monitor.sh
```

### 4. Automated Remediation (When under attack)
```bash
sudo auto-remediate.sh
```

### 5. Incident Response & Forensic Analysis
```bash
sudo incident-response.sh
# Reports saved in /var/log/security-incidents/
```

---

## 🤝 Contributing
Contributions and suggestions are welcome! Feel free to open an issue or submit a pull request.
