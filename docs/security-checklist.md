# Ubuntu Security Checklist (Competition Edition)

🔐 Basic Hardening & Must-Do's

## 1. User & Sudo Privileges
```bash
whoami && sudo -l
getent group sudo
sudo chmod 440 /etc/sudoers
```

## 2. Firewall (UFW)
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable
```

---

🕵️ Detecting Reconnaissance & Enumeration

In competitions, opposing teams will actively scan your system (port scanning, user enumeration, privilege escalation script scanning). Watch for:
1. **Port & Network Scans:** Check active connections and firewall logs (`/var/log/ufw.log`) for bursts of connection attempts.
2. **User Enumeration:** Look for spikes in `Invalid user` logs in `/var/log/auth.log`.
3. **Enumeration Tools:** Competitors often run scripts like **LinPEAS**, **LinEnum**, or **pspy**. Check process list:
   ```bash
   ps aux | grep -iE '(linpeas|linenum|pspy|nmap)'
   ```

---

💥 Defending Against Exploitation & RCE

1. **Service Account Shell Protection:**
   Service accounts (like `www-data`, `nginx`, `postgres`) should never have interactive shells (`/bin/false` or `/sbin/nologin`). Check `/etc/passwd`:
   ```bash
   grep -E '(www-data|nginx|apache|postgres|nobody)' /etc/passwd
   ```
2. **Reverse Shell Detection:**
   Monitor established outbound connections to unexpected external IPs:
   ```bash
   sudo ss -tunp | grep ESTABLISHED
   ```
3. **SUID / SGID Binary Auditing:**
   Regularly check for newly created SUID binaries used for privilege escalation:
   ```bash
   find / -perm -4000 -type f 2>/dev/null
   ```

---

🚨 Quick Red Flags
- Spikes in failed SSH passwords or invalid usernames.
- Service accounts running bash/sh processes.
- Unknown files in `/tmp` or `/dev/shm`.
- Changes to `/etc/sudoers` or unauthorized users in `sudo`.
