# Lab 01: Solution

## Answers

| # | Answer |
|---|--------|
| 1 | **192.168.1.105** |
| 2 | **admin, administrator, user01** |
| 3 | **47 failed attempts** |
| 4 | **2024-03-15 14:32:18** |
| 5 | **Created scheduled task, downloaded malware, disabled defender** |

## Analysis Walkthrough

### Finding Failed Logins (Event ID 4625)

```powershell
# Sample output from Chainsaw
TimeCreated: 2024-03-15 14:28:12
EventID: 4625
LogonType: 10
IpAddress: 192.168.1.105
TargetUserName: admin
Status: 0xC000006D
```

### Pattern Analysis

1. **14:28:12 - 14:31:45**: 47 failed attempts targeting admin, administrator, user01
2. **14:32:18**: Successful login as "admin" from 192.168.1.105
3. **14:33:00**: New process - cmd.exe spawned
4. **14:33:45**: Scheduled task created (T1055 - Persistence)

### Key Event IDs

| Event ID | Description | Use Case |
|----------|-------------|----------|
| 4624 | Successful logon | Find initial access |
| 4625 | Failed logon | Identify brute force |
| 4634 | Logoff | Track session end |
| 4648 | Explicit credentials | Lateral movement |
| 4688 | New process | Post-exploitation |
| 4698 | Scheduled task | Persistence |

## Detection Sigma Rule

```yaml
title: RDP Brute Force Detection
status: experimental
logsource:
  product: windows
  service: security
detection:
  selection:
    EventID:
      - 4625
    LogonType: 10
  condition: selection | count(IpAddress) by TargetUserName > 5
level: medium
```

## Mitigation Recommendations

1. **Account Lockout Policy** - Lock after 5 failed attempts
2. **MFA** - Enable Network Level Authentication
3. **IP Allowlist** - Restrict RDP to known IPs
4. **Monitoring** - Alert on 4625 patterns