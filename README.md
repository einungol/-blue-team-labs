# Blue Team Labs 🎯

> Practice DFIR (Digital Forensics & Incident Response) with real-world scenarios

## Overview

A beginner-friendly blue team training repository with 6 hands-on scenarios covering:
- Brute Force Attack Analysis
- Malware Analysis
- Memory Forensics
- Network Traffic Analysis
- Privilege Escalation Investigation
- Phishing Email Investigation

## Difficulty: Beginner ⭐

Each lab includes step-by-step guidance, sample logs, and analysis scripts.

## Quick Start

```bash
# Clone this repository
git clone https://github.com/einungol/-blue-team-labs.git
cd -blue-team-labs

# Start with Lab 01 - Brute Force
cd 01-bruteforce
```

## Lab Structure

| Lab | Topic | Tools |
|-----|-------|-------|
| 01 | Brute Force Attack | Windows Event Logs, Chainsaw |
| 02 | Malware Analysis | ANY.RUN, Hybrid Analysis |
| 03 | Memory Forensics | Volatility, Rekall |
| 04 | Network Analysis | Wireshark, Zeek |
| 05 | Privilege Escalation | Linux logs, LINPEAS |
| 06 | Phishing Investigation | Email headers, URLs |

## Prerequisites

- WSL2 or Linux VM (for Linux-based tools)
- Windows VM (for Windows Event Logs)
- Docker (optional - for Splunk/ELK)

## Tools Installation

```bash
# Run the installation script
chmod +x scripts/install-tools.sh
./scripts/install-tools.sh
```

## Contributing

PRs welcome! Add new scenarios or improve existing walkthroughs.

## License

MIT

---

**Start with:** [Lab 01 - Brute Force Attack](01-bruteforce/README.md)