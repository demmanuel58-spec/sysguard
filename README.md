# ⚡ SysGuard: Enterprise Server Health & Incident Alerting Engine

A modular, POSIX-compliant system monitoring utility built in Bash. SysGuard acts as a zero-dependency monitoring sidecar that continuously inspects core host metrics (CPU load, RAM utilization, disk/inode storage), captures live diagnostic snapshots of offending process trees, and dispatches real-time JSON webhook alerts to Slack, Discord, or custom operational dashboards.

![Linux](https://img.shields.io/badge/Platform-Linux%20%2F%20POSIX-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Bash](https://img.shields.io/badge/Language-Bash%20Shell-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![Alerting](https://img.shields.io/badge/Integration-Slack%20%2F%20Webhooks-4A154B?style=for-the-badge&logo=slack&logoColor=white)
![Systemd](https://img.shields.io/badge/Service-Systemd%20Timer-4D4D4D?style=for-the-badge&logo=systemd&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

---

## 🎯 Target Audience & Operational Value

SysGuard was engineered specifically for **DevOps Engineers, SREs, Systems Administrators, and Backend Developers** who manage Linux VMs, micro-instances, or cloud servers (AWS EC2, GCP, DigitalOcean) and need lightweight, reliable health monitoring without the bloat of heavy third-party APM agents.

### 💡 Why Use SysGuard?
* **Zero Runtime Overhead:** Built natively using POSIX-compliant Bash and core Linux utilities (`top`, `ps`, `df`, `awk`). No Python runtimes, Node.js packages, or heavy Docker daemons required.
* **Actionable Root-Cause Alerts:** Traditional alerts only tell you *"CPU is at 95%."* SysGuard captures a live snapshot of the top-5 resource-consuming PIDs and attaches the exact process tree to your Slack or Discord webhook payload.
* **Systemd-Native Automation:** Installs as a background Linux daemon using native `systemd` service and timer units for headless, 24/7 server protection.

---

## 🎯 Problem Solved
Production servers frequently crash due to unmonitored disk space exhaustion, memory leaks, or runaway background processes. Setting up massive enterprise agents (like Datadog or New Relic) is often cost-prohibitive or overkill for targeted API nodes and VPS deployments.

**SysGuard** provides an automated, lightweight, zero-dependency alternative that inspects system internals natively, isolates process bottlenecks, and alerts on-call teams before outages impact end users.

---

## 🏗️ Architecture & Directory Layout

```
sysguard/
├── bin/
│   └── sysguard              # Main CLI entrypoint executable
├── lib/
│   ├── utils.sh              # Shared functions: logging, color output, lockfiles
│   └── alerter.sh            # JSON payload builder & webhook HTTP dispatcher
├── config/
│   └── sysguard.conf         # Centralized system thresholds & settings
├── systemd/
│   ├── sysguard.service      # Systemd background service unit
│   └── sysguard.timer        # Systemd timer unit schedule
├── install.sh                # Automated installer & systemd setup script
└── README.md                 # System documentation

```
---

## 💡 Key Technical Features

* **Modular System Architecture:**  Clean separation of executable entry points (bin/), reusable function libraries (lib/), and user configuration (config/).

* **Process Snapshot Capture:**  Automatically queries the process table (ps) upon threshold violations to attach a top-5 resource-consuming PID snapshot directly to incident alerts.

* **Kernel-Level Concurrency Control:**  Utilizes flock file locking to prevent race conditions or overlapping background executions.

* **Defensive Error Handling:**  Enforces set -euo pipefail and custom error traps to ensure immediate, predictable failure if pipes break or variables are unbound.

---

## 🚀 Quickstart & Installation

**1. Clone & Run Automated Setup**
```
git clone [https://github.com/YOUR_USERNAME/sysguard.git](https://github.com/demmanuel58-spec/sysguard.git)
cd sysguard
chmod +x install.sh
sudo ./install.sh
```

**2. Manual CLI Execution**
You can run a diagnostic sweep directly from your terminal:
```
sysguard --check
```

---

## ⚙️ Configuration (config/sysguard.conf)
Adjust resource limits and alerts in config/sysguard.conf:
```
# Alert Thresholds (Percentage) 
CPU_CRITICAL_THRESHOLD=90
MEM_CRITICAL_THRESHOLD=92
DISK_CRITICAL_THRESHOLD=95

# Webhook Notifications
WEBHOOK_ENABLE=true
WEBHOOK_URL="[https://hooks.slack.com/services/YOUR/WEBHOOK/URL](https://hooks.slack.com/services/YOUR/WEBHOOK/URL)"

# Logging Options
LOG_FILE="/var/log/sysguard.log"
```
---

##  📊 Sample Alert Output
When a threshold is breached, SysGuard dispatches a formatted payload to your configured webhook:
```
🚨 SYSGUARD INCIDENT ALERT: High CPU Utilization (94%)
Host: prod-api-node-01
Time: 2026-09-05 22:45:00

Top Process Consumers:
  PID  PPID COMMAND                  %CPU  %MEM
 1420  1012 /usr/bin/node server.js   88.4   6.2
 1102     1 /usr/bin/postgres         4.1   12.1
```
---

👤 Author
David Emmanuel Munyaka
* Backend Software Engineer
* GitHub: https://github.com/dammanuel58-spec
