# Real-time Monitoring Guide

Quick reference for real-time monitoring commands and scripts.

### Real-time Monitoring Script Setup

```bash
sudo nano /usr/local/bin/security-monitor.sh
sudo chmod +x /usr/local/bin/security-monitor.sh

# Watch output every 10 seconds
watch -n 10 /usr/local/bin/security-monitor.sh
```

### Key Monitoring Checks Included:
1. **Fail2Ban Status:** Banned IPs and total banned count.
2. **Recent SSH Attacks:** Failed password and invalid user attempts from `/var/log/auth.log`.
3. **Current SSH Connections:** Active established SSH sessions.
4. **System Status:** CPU load average, memory usage, and disk usage.
