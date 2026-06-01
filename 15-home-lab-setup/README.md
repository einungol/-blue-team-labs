# Lab 15: Home Lab Setup for Blue Team Practice

**Difficulty:** Beginner ⭐  
**Tools:** VirtualBox, Kali Linux, Splunk, Wireshark  
**Time:** 2-3 hours (one-time setup)

---

## Scenario

You want to practice blue team skills at home but don't know where to start. This guide will help you set up a home lab environment for security practice.

## Why Build a Home Lab?

- Practice SIEM and log analysis safely
- Learn to use security tools without affecting production systems
- Simulate attacks and defend against them
- Build a portfolio of hands-on experience
- Prepare for certifications

---

## Prerequisites

### Hardware Requirements
| Component | Minimum | Recommended |
|-----------|---------|-------------|
| CPU | 4 cores | 6+ cores |
| RAM | 8 GB | 16 GB |
| Storage | 100 GB SSD | 256+ GB SSD |
| VM Support | VT-x/AMD-V | VT-x/AMD-V enabled |

### Software Requirements
- [VirtualBox](https://www.virtualbox.org) or [VMware Workstation Player](https://www.vmware.com/products/workstation-player.html)
- 30+ GB free disk space

---

## Lab Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Host Machine (Windows/Mac/Linux)         │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐         │
│  │ Kali Linux  │  │  Windows 10  │  │  Splunk SIEM│         │
│  │ (Attacker)  │  │  (Victim)    │  │ (Detection) │         │
│  └─────────────┘  └─────────────┘  └─────────────┘         │
│        │                 │                 │                │
│        └─────────────────┴─────────────────┘                │
│                         │                                   │
│              ┌──────────┴──────────┐                        │
│              │   Internal Network   │                        │
│              │   (Host-only/NAT)    │                        │
│              └─────────────────────┘                        │
└─────────────────────────────────────────────────────────────┘
```

---

## Step-by-Step Setup

### Step 1: Install VirtualBox

```bash
# Windows (using Chocolatey)
choco install virtualbox -y

# macOS (using Homebrew)
brew install virtualbox

# Linux (Ubuntu/Debian)
sudo apt install virtualbox virtualbox-ext-pack
```

### Step 2: Create Virtual Machines

#### 2.1 Kali Linux (Attacker/Testing VM)
1. Download Kali Linux ISO from https://www.kali.org/get-kali/
2. Create new VM in VirtualBox:
   - Name: Kali-Linux
   - Type: Linux
   - Version: Debian (64-bit)
   - RAM: 2 GB
   - Disk: 50 GB
3. Install Kali Linux with default options
4. Update and install tools:
   ```bash
   sudo apt update && sudo apt upgrade -y
   sudo apt install metasploit-framework nmap wireshark
   ```

#### 2.2 Windows 10 (Victim VM)
1. Download Windows 10 ISO from Microsoft (or use trial)
2. Create new VM in VirtualBox:
   - Name: Windows-10
   - Type: Windows 10 (64-bit)
   - RAM: 4 GB
   - Disk: 80 GB
3. Install Windows 10
4. Disable Windows Defender (for lab practice only!):
   ```powershell
   # Run as Administrator
   Set-MpPreference -DisableRealtimeMonitoring $true
   ```
5. Install Sysmon:
   ```
   Download from: https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon
   sysmon -accepteula -i
   ```

#### 2.3 Security Onion / Splunk (SIEM VM)
**Option A: Security Onion (Recommended)**
1. Download Security Onion ISO from https://securityonionsolutions.com
2. Create VM:
   - Name: Security-Onion
   - RAM: 8 GB
   - Disk: 200 GB
3. Follow installation wizard

**Option B: Splunk Free**
1. Download Splunk Free from https://www.splunk.com
2. Create VM:
   - Name: Splunk-SIEM
   - RAM: 4 GB
   - Disk: 100 GB
3. Install Ubuntu Server first, then Splunk:
   ```bash
   sudo apt update
   wget -O splunk-9.0.1-linux-2.6-x86_64.rpm https://download.splunk.com/products/splunk/releases/9.0.1/linux/splunk-9.0.1-linux-2.6-x86_64.rpm
   sudo dpkg -i splunk-9.0.1-linux-2.6-x86_64.rpm
   sudo /opt/splunk/bin/splunk start
   ```

---

### Step 3: Network Configuration

1. In VirtualBox, create Internal Network:
   - Go to File > Host Network Manager
   - Create vboxnet0 (192.168.100.0/24)

2. Configure network adapters:

| VM | Adapter | Network |
|----|---------|---------|
| Kali-Linux | NAT | Internet |
| Kali-Linux | Host-only | 192.168.100.10 |
| Windows-10 | Host-only | 192.168.100.20 |
| Splunk-SIEM | Host-only | 192.168.100.30 |

3. Test connectivity:
   ```bash
   # From Kali
   ping 192.168.100.20  # Windows
   ping 192.168.100.30  # Splunk
   ```

---

### Step 4: Forward Logs to SIEM

#### 4.1 Windows: Install Splunk Forwarder
1. Download Splunk Forwarder from Splunk
2. Install on Windows 10 VM:
   ```powershell
   splunkforwarder-9.0.1-x64-setup.exe
   ```
3. Configure inputs.conf:
   ```
   [WinEventLog:Security]
   index = windows
   disabled = false

   [WinEventLog:System]
   index = windows
   disabled = false
   ```
4. Connect to Splunk server:
   ```powershell
   cd C:\Program Files\SplunkUniversalForwarder\bin
   .\splunk add forward-server 192.168.100.30:9997
   .\splunk start
   ```

#### 4.2 Linux: Rsyslog Configuration
```bash
# On Kali Linux
sudo vim /etc/rsyslog.conf
# Add:
*.* @@192.168.100.30:514

sudo systemctl restart rsyslog
```

---

### Step 5: Practice Scenarios

#### Scenario 1: Detect Brute Force Attack
1. From Kali, run brute force:
   ```bash
   hydra -l admin -P passwords.txt 192.168.100.20 rdp
   ```
2. Observe logs in Splunk
3. Write detection rule

#### Scenario 2: Malware Analysis
1. Download EICAR test file:
   ```bash
   curl -o eicar.com https://www.eicar.org/download/EICARARCTESTFILE2.COM
   ```
2. Analyze in ANY.RUN or upload to Splunk
3. Create detection rule

#### Scenario 3: Network Forensics
1. Run packet capture:
   ```bash
   # On Kali
   tcpdump -i eth0 -w capture.pcap
   ```
2. Analyze with Wireshark
3. Identify suspicious traffic

---

## Tools to Install

### Essential Tools
| Tool | Purpose | Link |
|------|---------|------|
| Wireshark | Packet analysis | wireshark.org |
| Nmap | Network scanning | nmap.org |
| Splunk Free | SIEM | splunk.com |
| VirtualBox | Virtualization | virtualbox.org |
| Sysmon | Windows monitoring | sysinternals |

### Blue Team Tools
| Tool | Purpose | Link |
|------|---------|------|
| Atomic Red Team | Adversary simulation | github.com/redcanaryco |
| sigma | Detection rules | github.com/SigmaHQ/sigma |
| YARA | Malware detection | virustotal.github.io |
| Zeek | Network monitoring | zeek.org |
| TheHive | Incident response | thehive-project.org |

---

## Learning Path

### Week 1: Lab Setup
- [x] Install VirtualBox
- [x] Set up Kali Linux
- [x] Set up Windows 10
- [x] Set up Splunk SIEM

### Week 2: Network Basics
- [ ] Learn Wireshark basics
- [ ] Capture and analyze normal traffic
- [ ] Identify protocols (TCP, UDP, DNS, HTTP)

### Week 3: Log Analysis
- [ ] Forward Windows logs to Splunk
- [ ] Write basic SPL queries
- [ ] Create dashboards

### Week 4: Detection
- [ ] Create Sigma rules
- [ ] Write YARA rules
- [ ] Build detection playbook

### Week 5: Attack & Defense
- [ ] Run Atomic Red Team tests
- [ ] Detect attacks in SIEM
- [ ] Document findings

---

## Troubleshooting

### VM Performance Issues
- Increase RAM allocation
- Enable VT-x in BIOS
- Use SSD for disk storage
- Reduce VM count (run 2 at a time)

### Network Connectivity
- Verify Host-only adapter is enabled
- Check Windows Firewall on host
- Ensure VMs are on same subnet

### Splunk Not Receiving Logs
- Verify forwarder is running
- Check port 9997 is open
- Review splunkd.log for errors

---

## Next Steps

After completing this lab:
1. Try [Lab 01 - Brute Force Analysis](../01-bruteforce/README.md)
2. Practice [Lab 07 - SIEM Analysis](../07-siem-analysis/README.md)
3. Advance to [Lab 11 - Threat Hunting](../11-threat-hunting/README.md)

---

## Additional Resources

- [VirtualBox Documentation](https://www.virtualbox.org/wiki/Documentation)
- [Splunk Free Documentation](https://docs.splunk.com/Documentation)
- [Security Onion Documentation](https://docs.securityonion.io)
- [Blue Team Tools Collection](https://github.com/fabrizioboldrini/awesome-blue-team)

---

## Challenge Questions

| # | Question | Answer |
|---|----------|--------|
| 1 | How do you forward Windows Event Logs to Splunk? | Use Splunk Universal Forwarder |
| 2 | What network mode allows VM-to-VM communication? | Host-only network |
| 3 | How do you capture network traffic on Linux? | tcpdump or Wireshark |
| 4 | What is Sysmon used for? | Windows process monitoring |
| 5 | What port does Splunk default forwarder use? | 9997 |

---

## Solution

This is a setup guide - there's no single solution. Follow the steps and verify each VM can:
- [ ] Access the internet (NAT adapter)
- [ ] Ping other VMs (Host-only adapter)
- [ ] Send/receive logs to Splunk
- [ ] Run security tools without errors

---

**Back to:** [Main README](../README.md)