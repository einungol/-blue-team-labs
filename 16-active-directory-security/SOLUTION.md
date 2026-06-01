# Lab 16: Active Directory Security - Solution

## Answers to Challenge Questions

### Question 1: Which user account was compromised first?
**Answer:** The `svc_backup` account was compromised first via RDP brute force from IP `10.0.0.50`.

**Evidence:**
```powershell
# Event ID 4625 - Failed login from suspicious IP
Get-WinEvent -FilterHashtable @{LogName='Security';ID=4625} |
  Where-Object { $_.Properties[18].Value -eq '10.0.0.50' }
```

Look for multiple failed logon events (4625) followed by successful logon (4624) from the same IP.

---

### Question 2: What privilege escalation technique was used?
**Answer:** Kerberoasting - Attacker requested TGS tickets for service accounts.

**Evidence:**
```powershell
# Event ID 4769 - Kerberos ticket requested
Get-WinEvent -FilterHashtable @{LogName='Security';ID=4769} |
  Where-Object { $_.Properties[6].Value -match 'svc_' }
```

The attacker used `GetUserSPNs.py` from Impacket to request service principal names.

---

### Question 3: Which accounts have Domain Admin privileges?
**Answer:**
- Administrator
- domain admins (group)
- svc_backup (added during attack)

**Commands:**
```powershell
# List Domain Admins
Get-ADGroupMember -Identity "Domain Admins" -Recursive |
  Select-Object Name, SamAccountName

# Check who has sensitive privileges (Event ID 4672)
Get-WinEvent -FilterHashtable @{LogName='Security';ID=4672}
```

---

### Question 4: What lateral movement was performed?
**Answer:** The attacker moved from the compromised server to:
1. `HR-WS-01` via SMB
2. `File-Server-01` via WinRM

**Evidence:**
```powershell
# Event ID 4688 - New process on other systems
# Check for PowerShell remoting
Get-WinEvent -FilterHashtable @{LogName='Security';ID=4688} |
  Where-Object { $_.Message -match 'powershell.exe' -and $_.Message -match 'RemotePowerShell' }

# SMB connections to other hosts
Get-WinEvent -FilterHashtable @{LogName='Security';ID=5140} |
  Where-Object { $_.Message -match '\\\\HR-WS-01' }
```

---

### Question 5: Recommended remediation steps?
**Answer:**

1. **Immediate (0-1 hour):**
   - Reset password of compromised accounts
   - Disable affected accounts
   - Isolate compromised systems from network

2. **Short-term (1-24 hours):**
   - Enable LDAP signing
   - Block NTLMv1
   - Implement MFA for privileged accounts

3. **Long-term (1-4 weeks):**
   - Deploy BloodHound for attack path analysis
   - Implement Tiered Admin model
   - Regular AD security audits
   - Deploy Microsoft LAPS

---

## Investigation Commands Reference

### Authentication Analysis
```powershell
# Find all failed logins
Get-WinEvent -FilterHashtable @{LogName='Security';ID=4625} -MaxEvents 1000 |
  Group-Object {$_.Properties[5].Value} |
  Sort-Object Count -Descending

# Find suspicious successful logins
Get-WinEvent -FilterHashtable @{LogName='Security';ID=4624} |
  Where-Object { $_.Properties[18].Value -notmatch '192.168.1|10.0.0' }
```

### Privilege Escalation Detection
```powershell
# Special privileges assigned (Event ID 4672)
Get-WinEvent -FilterHashtable @{LogName='Security';ID=4672} |
  Select-Object TimeCreated, @{N='Account';E={$_.Properties[0].Value}}

# Sensitive account usage
Get-ADUser -Filter * -Properties MemberOf |
  Where-Object { $_.MemberOf -match "Domain Admins" } |
  Select-Object Name, SamAccountName
```

### Lateral Movement Detection
```powershell
# SMB / Windows Admin Shares
Get-WinEvent -FilterHashtable @{LogName='Security';ID=5140} |
  Where-Object { $_.Message -match '\\\\' }

# Remote Desktop sessions
Get-WinEvent -FilterHashtable @{LogName='Security';ID=4624} |
  Where-Object { $_.Properties[8].Value -eq 10 }
```

---

## IOC Summary

| Type | Value |
|------|-------|
| Compromised IP | 10.0.0.50 |
| Initial Account | svc_backup |
| Escalation | Kerberoasting |
| Lateral Movement | SMB, WinRM |
| Duration | 3 days |

---

## References

- [MITRE ATT&CK T1087 - Account Discovery](https://attack.mitre.org/techniques/T1087/)
- [Microsoft Event ID 4769](https://learn.microsoft.com/en-us/windows/security/threat-protection/auditing/event-4769)
- [BloodHound](https://github.com/BloodHoundAD/BloodHound)

---

**Back to:** [README.md](README.md)