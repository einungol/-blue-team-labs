# Complete Blue Team Lab Platform Guide

> สร้างแพลตฟอร์มแบบ TryHackMe/HackTheBox แต่สำหรับ Blue Team

---

## 📋 Overview

| Aspect | Details |
|--------|---------|
| **Goal** | สร้าง Blue Team Training Platform ครบวงจร |
| **Duration** | 4-8 สัปดาห์ |
| **Cost** | ฟรี (Docker) ถึง $100+/เดือน |
| **Output** | SIEM, Detection Engineering, Threat Hunting |

---

## 🗺️ Roadmap

```
Week 1-2     Week 3-4      Week 5-6      Week 7-8
    │            │            │            │
    ▼            ▼            ▼            ▼
┌────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐
│Docker  │  │Vulnerable│  │  Active  │  │Complete  │
│SOC Lab │  │   Apps   │  │Directory │  │ Platform │
│(Basic) │  │(Attack)  │  │  (AD)    │  │(Launch!) │
└────────┘  └──────────┘  └──────────┘  └──────────┘
```

---

# Phase 1: Docker SOC Lab (Week 1-2)

## 1.1 เตรียม Server

### Minimum Requirements:
| Component | Minimum | Recommended |
|-----------|---------|-------------|
| CPU | 4 cores | 8+ cores |
| RAM | 8 GB | 16 GB |
| Storage | 100 GB | 256 GB SSD |
| OS | Ubuntu 20.04+ | Ubuntu 22.04 |

### Install Docker:
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
newgrp docker

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker --version
docker-compose --version
```

---

## 1.2 Deploy SOC Lab Docker

### Clone and Setup:
```bash
# Clone SOC Lab Docker
git clone https://github.com/Josperdo/soc-lab-docker.git
cd soc-lab-docker

# Start the lab
docker-compose up -d

# Check status
docker-compose ps
```

### Access Points:
| Service | URL | Default Credentials |
|---------|-----|---------------------|
| Kibana | http://localhost:5601 | elastic / changeme |
| Elasticsearch | http://localhost:9200 | - |
| Metabase | http://localhost:3000 | metabase / metabase |

### รอประมาณ 3-5 นาที แล้วลองเข้า Kibana ดู

---

## 1.3 เรียนรู้ Basic SIEM Queries

### Elasticsearch Basic Queries:

```bash
# View all logs
GET /logs/_search

# Search for failed logins
GET /logs/_search
{
  "query": {
    "match": { "event_id": "4625" }
  }
}

# Search for PowerShell execution
GET /logs/_search
{
  "query": {
    "match": { "process_name": "powershell.exe" }
  }
}

# Count by event type
GET /logs/_search
{
  "size": 0,
  "aggs": {
    "by_event": {
      "terms": { "field": "event_id" }
    }
  }
}
```

### Practice Exercises:
1. ค้นหา failed login attempts
2. หา PowerShell suspicious commands
3. หา network connections ผิดปกติ
4. สร้าง dashboard แสดง security events

---

## 1.4 Challenge: Detect the Attack

### Run Attack Simulation:
```bash
# In Kali Linux container
docker exec -it kali apt update && apt install -y hydra

# Brute force simulation
hydra -l admin -P /usr/share/wordlists/rockyou.txt 10.0.0.100 rdp

# PowerShell simulation
docker exec -it kali powershell -Command "Invoke-Mimikatz"
```

### Then Analyze in Kibana:
- หา event ID 4625 (failed login)
- หา event ID 4624 (successful login)
- หา powershell.exe spawned
- เขียน Sigma rule สำหรับ detect

---

# Phase 2: Vulnerable Apps (Week 3-4)

## 2.1 เพิ่ม DVWA (Vulnerable Web App)

### Create DVWA Container:
```bash
# Create directory
mkdir -p /opt/vulnerable-apps && cd /opt/vulnerable-apps

# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  dvwa:
    image: sagikazarmark/dvwa
    ports:
      - "8080:80"
    environment:
      - WEB_PORT=80
    privileged: true
    volumes:
      - dvwa-data:/var/www/html/hackable/uploads
      - dvwa-config:/var/www/html/config

volumes:
  dvwa-data:
  dvwa-config:
EOF

# Start DVWA
docker-compose up -d

# Access http://your-server:8080
# Default credentials: admin / password
```

---

## 2.2 เพิ่ม OWASP Juice Shop

```bash
# In same directory, add to docker-compose.yml
  juice-shop:
    image: bkimminich/juice-shop
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=security
```

### Restart:
```bash
docker-compose -f docker-compose.yml up -d
```

---

## 2.3 Attack & Detect Training

### Attack Scenarios:

| Challenge | Target | Blue Team Skill |
|-----------|--------|-----------------|
| SQL Injection | DVWA | Log analysis, WAF rules |
| XSS | Juice Shop | Request logging |
| Brute Force | DVWA Login | Alert on multiple failures |
| File Upload | DVWA | Malware detection |
| Command Injection | DVWA | Sysmon rules |

### Detection Rules to Create:

#### Sigma Rule - Brute Force Detection:
```yaml
title: RDP Brute Force Detection
id: rdp-brute-force-001
status: experimental
logsource:
  category: windows
  product: security
detection:
  selection:
    EventID: 4625
  condition:
    count:
      by: IpAddress
      gte: 5
  timeframe: 5m
level: high
```

#### Sigma Rule - Suspicious PowerShell:
```yaml
title: Suspicious PowerShell Encoded Command
id: powershell-encoded-001
logsource:
  category: process_creation
  product: windows
detection:
  selection:
    CommandLine|contains: '-enc '
  condition: selection
level: medium
```

---

# Phase 3: Active Directory (Week 5-6)

## 3.1 สร้าง AD Lab ด้วย Proxmox หรือ VirtualBox

### Architecture:
```
┌─────────────────────────────────────────────────────────────┐
│                    Home Lab Network                         │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐     ┌──────────────┐     ┌────────────┐ │
│  │   Windows    │     │   Windows    │     │    Kali    │ │
│  │   Server     │     │   10 Client  │     │   Linux    │ │
│  │  (Domain     │◀───▶│  (Workstation)│◀───▶│  (Attacker)│ │
│  │   Controller)│     │              │     │            │ │
│  └──────────────┘     └──────────────┘     └────────────┘ │
│        │                                              │     │
│        └────────────────┬─────────────────────────────┘     │
│                         ▼                                   │
│                  ┌──────────┐                               │
│                  │  Wazuh   │  ← SIEM Monitoring           │
│                  │  Server  │                               │
│                  └──────────┘                               │
└─────────────────────────────────────────────────────────────┘
```

### VMs ที่ต้องสร้าง:

| VM | OS | RAM | Role |
|----|----|-----|------|
| DC01 | Windows Server 2019/2022 | 4 GB | Domain Controller |
| WS01 | Windows 10 | 4 GB | Workstation |
| WS02 | Windows 10 | 4 GB | Workstation |
| KALI | Kali Linux | 2 GB | Attacker |

---

## 3.2 Install Windows Server as DC

### Step 1: Download Windows Server Evaluation
```bash
# Download Windows Server 2022 ISO
# https://www.microsoft.com/en-us/evalcenter/download-windows-server-2022
```

### Step 2: Install and Configure

```powershell
# Set static IP
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress "192.168.56.10" -PrefixLength 24

# Install AD DS
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Create new forest
Install-ADDSForest -DomainName "corp.lab" -DomainNetbiosName "CORP" `
  -DatabasePath "C:\Windows\NTDS" -LogPath "C:\Windows\NTDS" `
  -SysvolPath "C:\Windows\SYSVOL" -Force
```

### Step 3: Create Vulnerable Users

```powershell
# Create weak password user (AS-REP roastable)
New-ADUser -Name "svc_backup" -SamAccountName "svc_backup" `
  -UserPrincipalName "svc_backup@corp.lab" `
  -AccountPassword (ConvertTo-SecureString "Summer2024!" -AsPlainText -Force) `
  -Enabled $true -DoesNotRequirePreAuth

# Create service account (Kerberoastable)
New-ADUser -Name "svc_sql" -SamAccountName "svc_sql" `
  -UserPrincipalName "svc_sql@corp.lab" `
  -AccountPassword (ConvertTo-SecureString "P@ssw0rd123!" -AsPlainText -Force) `
  -Enabled $true -ServicePrincipalName "MSSQLSvc/sqlserver.corp.lab"
```

---

## 3.3 Install Wazuh Agent on Windows

```powershell
# Download and install Wazuh agent
Invoke-WebRequest -Uri "https://packages.wazuh.com/4.7/windows/wazuh-agent-4.7.0-1.msi" `
  -OutFile "C:\wazuh-agent.msi"

# Install silently
msiexec /i C:\wazuh-agent.msi /q WAZUH_MANAGER="192.168.56.20" WAZUH_AGENT_NAME="WS01"

# Start service
Start-Service wazuh-agent
```

---

## 3.4 AD Attack Scenarios to Practice

| Attack | Description | Detection Method |
|--------|-------------|------------------|
| **Kerberoasting** | Request TGS tickets | Event ID 4769 |
| **AS-REP Roasting** | Request no-preauth users | Event ID 4768 |
| **Pass-the-Hash** | Use NTLM hash | Event ID 4624 |
| **Golden Ticket** | Forge TGT | Event ID 4769 |
| **DCSync** | Dump DC secrets | Event ID 4662 |
| **SMB Lateral** | SMB to other hosts | Event ID 5140 |

### Detection Queries:

```spl
# Kerberoasting detection
index=windows EventID=4769 | stats count by AccountName | where count > 5

# Suspicious logon
index=windows EventID=4624 LogonType=10 | where src_ip != "192.168.56.0/24"
```

---

# Phase 4: Complete Platform (Week 7-8)

## 4.1 รวม blue-team-labs เป็น Challenges

### Create Challenge Format:

```markdown
# Challenge: Detect Brute Force Attack

## Scenario
A brute force attack is targeting the SIEM. Analyze the logs and answer:

1. What is the attacker IP?
2. How many failed attempts?
3. Which account was compromised?

## Files
- `logs/siem_events.json` - SIEM export

## Tools
- Kibana
- Splunk
- Excel

## Flag Format
BLUE{answer1_answer2_answer3}

## Points
100 points
```

### Challenge Categories:
| Category | Examples | Points |
|----------|----------|--------|
| Log Analysis | Find attack in logs | 50-100 |
| Malware Analysis | Extract IOCs | 100-150 |
| Detection Engineering | Write detection rule | 150-200 |
| Incident Response | Contain threat | 100-150 |
| Forensics | Analyze dump | 150-200 |

---

## 4.2 สร้าง User Management System

### Option A: Use CTFd
```bash
# Install CTFd
git clone https://github.com/CTFd/CTFd.git
cd CTFd
docker-compose up -d

# Access http://localhost:8000
```

### Add Challenges:
1. Create challenge category "Blue Team"
2. Add challenges from blue-team-labs
3. Set points and flags
4. Enable scoreboard

---

## 4.3 OpenVPN Access (Optional)

### Create VPN for Remote Access:
```bash
# Install OpenVPN
sudo apt install openvpn easy-rsa

# Setup CA
cd /usr/share/easy-rsa
sudo ./easyrsa init-pki
sudo ./easyrsa build-ca

# Build server
sudo ./easyrsa build-server-full server nopass

# Build client
sudo ./easyrsa build-client-full user1 nopass

# Copy configs
sudo cp pki/ca.crt /etc/openvpn/
sudo cp pki/issued/server.crt /etc/openvpn/
sudo cp pki/private/server.key /etc/openvpn/
```

---

## 4.4 Launch Your Platform

### Checklist ก่อนเปิด:
- [ ] SIEM ใช้งานได้
- [ ] Vulnerable apps ทำงาน
- [ ] AD environment พร้อม
- [ ] Challenges สร้างแล้ว
- [ ] User registration ใช้งานได้
- [ ] VPN พร้อม (ถ้าต้องการ)

### Launch:
1. เชิญเพื่อนมาลอง
2. โพสต์บน LinkedIn
3. สร้าง YouTube walkthrough
4. เปิด GitHub repo สำหรับ platform

---

# 📋 Summary

## สิ่งที่จะได้จาก Platform:

| Component | Tool | Usage |
|-----------|------|-------|
| SIEM | Elasticsearch + Kibana | Log analysis |
| Network Detection | Suricata, Zeek | Network monitoring |
| Endpoint | Wazuh Agent | Windows/Linux monitoring |
| Threat Intel | MISP | IOC sharing |
| Purple Team | Caldera | Attack simulation |
| Challenges | CTFd | User management |
| Detection Rules | Sigma, YARA | Custom detections |

## ค่าใช้จ่าย:

| Option | Cost | Details |
|--------|------|---------|
| Docker Only | ฟรี | RAM 8GB, 4 CPU |
| Proxmox | ~$0-50/เดือน | Old PC or cloud VM |
| Cloud (AWS) | ~$100-150/เดือน | More realistic |

---

# 🔗 Resources

## GitHub Repositories:
- [SOC Lab Docker](https://github.com/Josperdo/soc-lab-docker)
- [Advanced SOC Lab](https://github.com/sandeepmothukuri/Enterprise-Detection-Engineering-SOC-Lab)
- [AWS SOC Lab](https://github.com/sivolko/aws-soc-lab-wazuh)
- [BlueTeam.Lab](https://github.com/op7ic/BlueTeam.Lab)
- [CTFd](https://github.com/CTFd/CTFd)

## Vulnerable Apps:
- [Metasploitable 3](https://github.com/rapid7/metasploitable3)
- [DVWA](https://www.dvwa.co.uk/)
- [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/)
- [VulnHub](https://www.vulnhub.com/)

---

**Guide Version:** 1.0  
**Last Updated:** 2024-03-20

**Related:**
- [Blue Team Labs Repository](../README.md)
- [Career Path Guide](CAREER-PATH.md)
- [Case Studies](CASE-STUDY-01-Ransomware.md)