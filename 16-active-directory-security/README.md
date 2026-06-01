# Lab 16: Active Directory Security

**Difficulty:** Intermediate ⭐⭐  
**Tools:** Windows Event Logs, BloodHound, ldapsearch  
**Time:** 45 minutes

## Scenario

Your organization's Active Directory was compromised. Investigate AD logs to identify the attack path and privilege escalation.

### Questions:
1. Which user account was compromised first?
2. What privilege escalation technique was used?
3. Which accounts have Domain Admin privileges?
4. What lateral movement was performed?
5. Recommended remediation steps?

## Prerequisites

### Knowledge Required
- Active Directory concepts
- Windows authentication (Kerberos, NTLM)
- AD privilege escalation techniques

### Tools Needed
- [BloodHound](https://github.com/BloodHoundAD/BloodHound) - AD analysis
- [ldapsearch](https://linux.die.net/man/1/ldapsearch) - LDAP query tool
- [PurpleAD](https://github.com/INFOSEC-Adventures/PurpleAD) - AD security tool

### Pre-Reading (Optional)
- [AD Attack Paths](https://attack.mitre.org/techniques/T1087/)
- [BloodHound Quick Start](https://bloodhound.readthedocs.io/en/latest/)

---

## Step-by-Step Walkthrough

### Step 1: Analyze Authentication Logs

```powershell
# Look for failed logins (potential brute force)
Get-WinEvent -FilterHashtable @{LogName='Security';ID=4625} -MaxEvents 50

# Find successful logins from suspicious IPs
Get-WinEvent -FilterHashtable @{LogName='Security';ID=4624} |
  Where-Object { $_.Properties[18].Value -eq '10.0.0.50' }
```

### Step 2: Check for Privilege Escalation

```powershell
# Event ID 4672 - Special privileges assigned
Get-WinEvent -FilterHashtable @{LogName='Security';ID=4672}
```

### Step 3: Identify Domain Admin Members

```powershell
# Get Domain Admins
Get-ADGroupMember -Identity "Domain Admins" -Recursive
```

### Step 4: Look for Kerberoasting

```powershell
# Event ID 4769 - A Kerberos ticket was requested
Get-WinEvent -FilterHashtable @{LogName='Security';ID=4769}
```

### Step 5: Check for DCSync

```powershell
# Event ID 4662 - Permission on object was evaluated
# Look for "Replicate Directory Changes All"
```

## Challenge Questions

| # | Question | Hint |
|---|----------|------|
| 1 | Initial compromise | Check Event ID 4624 from non-standard IP |
| 2 | Privilege escalation | Look for Event ID 4672 |
| 3 | Domain Admins | Check group membership changes |
| 4 | Lateral movement | Look for SMB connections to other hosts |
| 5 | Remediation | Reset compromised passwords, disable accounts |

## Solution

See [SOLUTION.md](SOLUTION.md)

---

## Additional Practice

- Run BloodHound to visualize attack paths
- Test detection of Pass-the-Hash
- Practice Golden Ticket detection

---

**Back to:** [Main README](../README.md)