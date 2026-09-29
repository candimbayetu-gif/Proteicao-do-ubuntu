# 🛡️ Proteção do Ubuntu (Competition & Security Edition)

A lightweight, practical toolkit of scripts, detection monitors, automated remediation, and forensic tools for hardening, securing, and monitoring Ubuntu servers.

---

## 📂 Repository Structure

* `scripts/security-monitor.sh`: Real-time monitoring script for system health, privilege escalation, sudo activity, reconnaissance, and reverse shells.
* `scripts/auto-remediate.sh`: Automated remediation script to lock down permissions, enforce firewall, kill malicious service shells, and secure SSH.
* `scripts/incident-response.sh`: Forensic snapshot tool that dumps active connections, process trees, SUID binaries, and auth logs into timestamped reports for post-incident analysis.
* `docs/security-checklist.md`: Essential security and hardening checklist for Ubuntu systems.

---

## 🚀 Quick Installation & Usage

### 1. Install Scripts
```bash
sudo cp scripts/*.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/*.sh
```

### 2. Run the Security Monitor
```bash
# Run once
security-monitor.sh

# Run continuously every 10 seconds
watch -n 10 security-monitor.sh
```

### 3. Automated Remediation (When under attack)
```bash
sudo auto-remediate.sh
```

### 4. Incident Response & Forensic Analysis
```bash
sudo incident-response.sh
# Reports saved in /var/log/security-incidents/
```

---

## 🤝 Contributing
Contributions and suggestions are welcome! Feel free to open an issue or submit a pull request.
