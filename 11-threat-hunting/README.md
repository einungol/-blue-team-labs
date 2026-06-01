# Lab 11: Threat Hunting with MITRE ATT&CK

**Difficulty:** Beginner ⭐  
**Tools:** MITRE ATT&CK, Sigma Rules, YARA  
**Time:** 45 minutes

## Prerequisites

### Knowledge Required
- Understanding of MITRE ATT&CK framework
- Familiarity with kill chain and attack stages
- Basic SIEM and log analysis concepts

### Tools Needed
- [MITRE ATT&CK Navigator](https://mitre-attack.github.io/attack-navigator/) - Threat hunting visualization
- [Sigma Rules](https://github.com/SigmaHQ/sigma) - Detection rules
- [Atomic Red Team](https://github.com/redcanaryco/atomic-red-team) - Adversary emulation

### Pre-Reading (Optional)
- [MITRE ATT&CK Overview](https://attack.mitre.org/resources/getting-started/)
- [Threat Hunting Fundamentals](https://www.sans.org/reading-room/whitepapers/analyst/mind-you-threat-hunting-406)

## Scenario

You are a Threat Hunter. Your SIEM has detected some anomalies. Use MITRE ATT&CK framework to investigate.

### Questions:
1. Which MITRE ATT&CK technique is likely involved?
2. What is the suspicious process?
3. What is the indicator of compromise?
4. How would you detect this?
5. Recommended response?

## Step-by-Step Walkthrough

### Step 1: Review Alerts

```
Alert: Suspicious PowerShell Execution
- Frequency: 15 times in 1 hour
- User: admin workstation
- Command: powershell -enc ...
```

### Step 2: Map to MITRE ATT&CK

| Alert | Likely Technique |
|-------|------------------|
| PowerShell -enc | T1059 - Command and Scripting Interpreter |
| New service | T1543 - Create or Modify System Process |
| Scheduled task | T1053 - Scheduled Task/Job |

### Step 3: Hunt for IOCs

```bash
# Search for PowerShell encoded commands
grep -r "powershell.*-enc" logs/

# Look for unusual scheduled tasks
schtasks /query /fo LIST
```

### Step 4: Create Detection Rule

```yaml
title: Suspicious PowerShell Encoded Command
detection:
  selection:
    Image: '*powershell.exe'
    CommandLine|contains: '-enc'
  condition: selection
```

## Challenge Questions

| # | Question | Expected Answer |
|---|----------|-----------------|
| 1 | Technique | T1059.001 - PowerShell |
| 2 | Process | powershell.exe |
| 3 | IOC | Base64 encoded command |
| 4 | Detection | Sigma rule + YARA |
| 5 | Response | Isolate, analyze, remediate |

## Solution

See [SOLUTION.md](SOLUTION.md)