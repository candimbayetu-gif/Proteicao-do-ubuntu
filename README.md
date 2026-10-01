# 🛡️ Proteção do Ubuntu (Competition & Security Edition)

A lightweight, practical toolkit of scripts, detection monitors, automated remediation, and forensic tools for hardening, securing, and monitoring Ubuntu servers.

---

## ⚡ One-Click Installation & Setup

To pull directly from GitHub and install everything in your Ubuntu environment with a single command, run:

```bash
git clone https://github.com/candimbayetu-gif/Proteicao-do-ubuntu.git && cd Proteicao-do-ubuntu && chmod +x setup.sh && ./setup.sh
```

---

## 🚀 CLI Shortcut Commands (Installed Globally)

Once installed via `setup.sh`, you can run these commands from anywhere in your terminal:

* **`sec-monitor`**: Run the **Live SOC Dashboard** — continuous real-time security monitor refreshing every 5 seconds (system health, recon detection, sudo activity, reverse shells, active threat alerts with color-coded status; press `Ctrl + C` to exit).
* **`sec-remediate`**: Run automated remediation & lockdown (secures sudoers, enforces UFW, kills service shells, secures SSH).
* **`sec-incident`**: Generate a timestamped forensic snapshot report for incident response and score justification (`/var/log/security-incidents/`).

---

## 📂 Repository Structure

* `setup.sh`: One-click master installer and updater script.
* `scripts/security-monitor.sh`: Core monitoring engine.
* `scripts/auto-remediate.sh`: Automated defense script.
* `scripts/incident-response.sh`: Forensic report generator.
* `docs/security-checklist.md`: Essential security and hardening checklist.

---

## 🤝 Contributing
Contributions and suggestions are welcome! Feel free to open an issue or submit a pull request.
