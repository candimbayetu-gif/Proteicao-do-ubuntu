# 🛡️ Proteção do Ubuntu (Competition & Security Edition)

*“One command. Total defense. Zero friction.”* — A lightweight, practical, and insanely intuitive toolkit for hardening, securing, and monitoring Ubuntu servers.

---

## ⚡ One-Click Installation & Setup

To pull directly from GitHub and install everything in your Ubuntu environment with a single command, run:

```bash
git clone https://github.com/candimbayetu-gif/Proteicao-do-ubuntu.git && cd Proteicao-do-ubuntu && chmod +x setup.sh && ./setup.sh
```

---

## 🌟 All-in-One Master Defense Command

Instead of running tools separately, you can execute the entire defense suite (hardening + anti-DDoS + remediation + live SOC monitoring) in one fluid motion:

```bash
shield     # (or 'defend', 'proteicao')
```

---

## 🚀 Clean, Prefix-Free Individual CLI Commands

* **`shield`** (or **`defend`**, **`proteicao`**): Runs all defense layers and seamlessly transitions into the live SOC dashboard.
* **`monitor`**: Launch the **Executive SOC Security Dashboard** — real-time continuous security monitor refreshing every 20 seconds.
* **`harden`**: Run automated server hardening (Monit, UFW, sysctl kernel hardening).
* **`block`** (or **`antiddos`**): Run automated **Anti-DDoS & IP Flood Blocking** (SYN cookies, UFW rate limits, IP dropping).
* **`remediate`**: Run automated remediation & lockdown (sudoers, daemon shells, SSH).
* **`incident`**: Generate a timestamped forensic snapshot report (`/var/log/security-incidents/`).
* **`telemetry`**: Export structured JSON security telemetry for SIEM.

---

## 📂 Repository Structure

* `setup.sh`: One-click master installer and symlink creator.
* `scripts/master-shield.sh`: Unified master defense runner (`shield`).
* `scripts/security-monitor.sh`: Core live SOC monitoring engine (`monitor`).
* `scripts/auto-harden.sh`: Automated Monit & kernel hardening (`harden`).
* `scripts/anti-ddos.sh`: Automated anti-DDoS and IP flood blocking (`block`).
* `scripts/auto-remediate.sh`: Automated defense & lockdown (`remediate`).
* `scripts/incident-response.sh`: Forensic report generator (`incident`).
* `scripts/export-telemetry.py`: Structured JSON SIEM exporter (`telemetry`).
* `docs/soc-architecture.md`: Enterprise SOC architecture & compliance guide.

---

## 🤝 Contributing
Contributions and suggestions are welcome! Feel free to open an issue or submit a pull request.
