#!/bin/bash
# ==============================================================================
# 🍯 PROTEÇÃO DO UBUNTU - MULTI-PORT DECOY HONEYPOT TRAP
# Traps nmap scans and intrusion probes on high-value decoy ports with realistic banners.
# ==============================================================================

if [ "$EUID" -ne 0 ]; then
    echo "[-] honeypot requires root privileges to bind to decoy ports."
    echo "[*] Elevating privileges via sudo..."
    exec sudo "$0" "$@"
fi

HONEYPOT_DIR="/var/log/security-incidents"
mkdir -p "$HONEYPOT_DIR"
HONEYPOT_LOG="$HONEYPOT_DIR/honeypot.log"

echo "=== 🍯 ACTIVATING MULTI-PORT DECOY HONEYPOT ==="

# Allow decoy ports in UFW if UFW is active
if command -v ufw >/dev/null 2>&1 && ufw status | grep -q "Status: active"; then
    echo "[*] Configuring UFW rules for decoy honeypot ports..."
    for port in 21 23 2222 3306 6379 8080; do
        ufw allow "$port/tcp" comment "Honeypot decoy trap port" >/dev/null 2>&1 || true
    done
fi

touch "$HONEYPOT_LOG"
chmod 644 "$HONEYPOT_LOG"

# Start lightweight background Python multi-port listener
python3 -c "
import socket, threading, datetime, sys

# Decoy ports and realistic service banners
services = {
    21: (b'220 ProFTPD 1.3.5c Server ready.\r\n', 'FTP'),
    23: (b'Ubuntu 20.04.2 LTS\nlogin: ', 'Telnet'),
    2222: (b'SSH-2.0-OpenSSH_8.2p1 Ubuntu-4ubuntu0.5\r\n', 'SSH-Decoy'),
    3306: (b'J\x00\x00\x00\x0a5.7.33-0ubuntu0.18.04.1\x00\x08\x00\x00\x001#N!w>Y\x00\xff\xf7\x08\x02\x00\xff\x81\x15\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00root\x00', 'MySQL'),
    6379: (b'-ERR wrong number of arguments for \'config\' command\r\n', 'Redis'),
    8080: (b'HTTP/1.1 401 Unauthorized\r\nContent-Type: text/html\r\n\r\n<html><body><h1>401 Unauthorized - Admin Console</h1></body></html>\r\n', 'Web-Admin')
}

log_file = '$HONEYPOT_LOG'

def handle_client(client_socket, client_address, port, service_name):
    timestamp = datetime.datetime.now().isoformat()
    try:
        client_socket.settimeout(5.0)
        banner, _ = services[port]
        client_socket.sendall(banner)
        data = client_socket.recv(1024)
        payload = data.hex() if data else 'empty'
    except Exception:
        payload = 'timeout/no-data'
    
    log_entry = f'[{timestamp}] HONEYPOT_TRAP: Service={service_name} Port={port} SourceIP={client_address[0]} SourcePort={client_address[1]} PayloadHex={payload}\n'
    print(log_entry.strip())
    with open(log_file, 'a') as f:
        f.write(log_entry)
    
    try:
        client_socket.close()
    except Exception:
        pass

def start_server(port, service_name):
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    try:
        server.bind(('0.0.0.0', port))
        server.listen(10)
        print(f'[+] Decoy {service_name} active on port {port}')
        while True:
            client, addr = server.accept()
            threading.Thread(target=handle_client, args=(client, addr, port, service_name), daemon=True).start()
    except Exception as e:
        print(f'[-] Failed to bind decoy {service_name} on port {port}: {e}')

for port, (_, name) in services.items():
    threading.Thread(target=start_server, args=(port, name), daemon=True).start()

import time
while True:
    time.sleep(3600)
" > /var/log/security-incidents/honeypot_daemon.log 2>&1 &

echo "$!" > /var/run/protecao-honeypot.pid
echo "[+] Multi-port Honeypot trap active (PID: $(cat /var/run/protecao-honeypot.pid))."
echo "=== ✅ HONEYPOT TRAP DEPLOYED ==="
