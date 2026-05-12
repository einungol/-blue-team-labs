# Lab 01: Brute Force Attack Analysis

**Difficulty:** Beginner ⭐  
**Tools:** Windows Event Logs, Chainsaw, grep  
**Time:** 30 minutes

## Scenario

A Windows server was compromised via RDP brute force attack. Your task is to analyze the security logs and answer:

1. What is the attacker's source IP?
2. Which username(s) were targeted?
3. How many failed login attempts before success?
4. What time did the successful login occur?
5. What actions did the attacker take after gaining access?

## Files Provided

- `Security.evtx` - Windows Security Event Log
- `System.evtx` - Windows System Event Log

## Step-by-Step Walkthrough

### Step 1: Examine Security Log for Failed Logins

```powershell
# Using Chainsaw to find Event ID 4625 (Failed login)
chainsaw hunt Security.evtx --rules sigma/builtin/windows/authentication_failed_logon.yaml
```

### Step 2: Find Successful Login

```powershell
# Event ID 4624 = Successful logon
chainsaw hunt Security.evtx --rules sigma/builtin/windows/authentication_successful_logon.yaml
```

### Step 3: Identify Attacker IP

Look for logon type 10 (RemoteInteractive/RDP) with failed then successful attempts from same IP.

### Step 4: Check for Post-Breach Activity

```powershell
# Event ID 4688 = New process creation
# Event ID 4698 = Scheduled task created
grep "cmd.exe" Security.evtx
grep "powershell.exe" Security.evtx
```

## Challenge Questions

| # | Question | Hint |
|---|----------|------|
| 1 | Attacker's IP | Look for repeated 4625 events from same source |
| 2 | Targeted username | Check Logon Type 10 failed attempts |
| 3 | Failed attempts count | Count 4625 events before first 4624 |
| 4 | Success timestamp | Find first 4624 with same username+IP |
| 5 | Post-access actions | Check 4688 for new processes |

## Solution

See [SOLUTION.md](SOLUTION.md) after you complete the challenge.

## Additional Practice

- Try using DeepBlueCLI instead of Chainsaw
- Parse EVTX with PowerShell directly
- CreateSigma rules to detect this attack