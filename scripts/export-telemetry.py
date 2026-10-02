#!/usr/bin/env python3
"""
🛡️ Proteção do Ubuntu - Advanced Telemetry & SIEM JSON Exporter
Inspired by Master Ollama's Architectural Audit: Advanced Log Collection & Parsing (LCP).
"""

import json
import os
import subprocess
import sys
from datetime import datetime, timezone

TELEMETRY_DIR = "/var/log/security-incidents"
TELEMETRY_FILE = os.path.join(TELEMETRY_DIR, "telemetry.json")

def ensure_root():
    if os.geteuid() != 0:
        print("[-] telemetry requires root privileges to read system logs and write telemetry.")
        print("[*] Elevating privileges via sudo...")
        try:
            os.execvp("sudo", ["sudo", "python3"] + sys.argv)
        except Exception as e:
            print(f"[-] Failed to auto-elevate: {e}")
            sys.exit(1)

def run_cmd(cmd):
    try:
        res = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=5)
        return res.stdout.strip()
    except Exception:
        return ""

def collect_telemetry():
    timestamp = datetime.now(timezone.utc).isoformat()
    
    # Active sessions
    sessions_raw = run_cmd("who 2>/dev/null")
    sessions = []
    for line in sessions_raw.splitlines():
        parts = line.split()
        if parts:
            sessions.append({
                "user": parts[0],
                "terminal": parts[1] if len(parts) > 1 else "",
                "login_time": " ".join(parts[2:4]) if len(parts) > 3 else "",
                "origin": parts[4].strip("()") if len(parts) > 4 else "local"
            })

    # UFW Firewall blocks from kern.log
    ufw_blocks = run_cmd("grep -i 'UFW BLOCK' /var/log/kern.log 2>/dev/null | tail -n 10")
    block_count = int(run_cmd("grep -i 'UFW BLOCK' /var/log/kern.log 2>/dev/null | wc -l") or "0")

    # Failed SSH login attempts
    failed_ssh = run_cmd("grep -E 'Failed password|Invalid user' /var/log/auth.log 2>/dev/null | tail -n 10")
    failed_count = int(run_cmd("grep -E 'Failed password|Invalid user' /var/log/auth.log 2>/dev/null | wc -l") or "0")

    # Snort NIDS alerts parsing
    snort_log = "/var/log/snort/alert.fast" if os.path.exists("/var/log/snort/alert.fast") else "/var/log/snort/alert"
    snort_alerts = run_cmd(f"tail -n 10 {snort_log} 2>/dev/null") if os.path.exists(snort_log) else ""

    # Running recon tools check
    recon_procs = run_cmd("ps aux | grep -iE '(linpeas|linenum|pspy|nmap|netcat|nc\.traditional|socat|hydra|sqlmap)' | grep -v grep")
    recon_detected = bool(recon_procs)

    payload = {
        "timestamp": timestamp,
        "system": {
            "load_avg": run_cmd("uptime"),
            "memory_usage": run_cmd("free -m | grep Mem"),
            "disk_usage": run_cmd("df -h / | tail -n 1")
        },
        "security_metrics": {
            "active_sessions_count": len(sessions),
            "active_sessions": sessions,
            "ufw_total_blocks": block_count,
            "recent_ufw_blocks": ufw_blocks.splitlines(),
            "failed_auth_count": failed_count,
            "recent_failed_auth": failed_ssh.splitlines(),
            "snort_alerts": snort_alerts.splitlines() if snort_alerts else [],
            "recon_tools_detected": recon_detected,
            "recon_processes": recon_procs.splitlines() if recon_procs else []
        }
    }
    return payload

def main():
    ensure_root()
    os.makedirs(TELEMETRY_DIR, exist_ok=True)
    payload = collect_telemetry()
    with open(TELEMETRY_FILE, "w") as f:
        json.dump(payload, f, indent=2)
    print(f"[+] Structured telemetry successfully exported to {TELEMETRY_FILE}")
    print(json.dumps(payload, indent=2))

if __name__ == "__main__":
    main()
