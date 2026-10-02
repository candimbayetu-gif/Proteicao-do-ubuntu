# 🛡️ Proteção do Ubuntu (Competition & Security Edition)

*“Simplicity is the ultimate sophistication.”* — A lightweight, practical, and insanely intuitive toolkit for hardening, securing, and monitoring Ubuntu servers.

---

## ⚡ One-Click Installation & Setup

To pull directly from GitHub and install everything in your Ubuntu environment with a single command, run:

```bash
git clone https://github.com/candimbayetu-gif/Proteicao-do-ubuntu.git && cd Proteicao-do-ubuntu && chmod +x setup.sh && ./setup.sh
```

---

## 🚀 Clean, Prefix-Free CLI Commands (Installed Globally)

Once installed, you can run these clean, single-word commands from anywhere in your terminal:

* **`monitor`**: Launch the **Executive SOC Security Dashboard** — real-time continuous security monitor refreshing every 20 seconds (system health, Executive Anomaly Verdict, active access sessions, brute-force attack intelligence, recon tool detection, and RCE shells; press `Ctrl + C` to exit).
* **`harden`**: Run automated server hardening — automatically configures **Monit**, enforces active **UFW** firewall rules, and applies sysctl kernel hardening.
* **`remediate`**: Run automated remediation & lockdown — secures sudoers, daemon shells, and enforces SSH hardening.
* **`incident`**: Generate a timestamped forensic snapshot report for incident response (`/var/log/security-incidents/`) with auto-sudo elevation.
* **`telemetry`**: Export structured JSON security telemetry for SIEM and compliance dashboard integration.

---

## 📂 Repository Structure

* `setup.sh`: One-click master installer and symlink creator.
* `scripts/security-monitor.sh`: Core live SOC monitoring engine (`monitor`).
* `scripts/auto-harden.sh`: Automated Monit & kernel hardening (`harden`).
* `scripts/auto-remediate.sh`: Automated defense & lockdown (`remediate`).
* `scripts/incident-response.sh`: Forensic report generator (`incident`).
* `scripts/export-telemetry.py`: Structured JSON SIEM exporter (`telemetry`).
* `docs/soc-architecture.md`: Enterprise SOC architecture & compliance guide.
* `docs/security-checklist.md`: Essential security and hardening checklist.

---

## 🤝 Contributing
Contributions and suggestions are welcome! Feel free to open an issue or submit a pull request.
