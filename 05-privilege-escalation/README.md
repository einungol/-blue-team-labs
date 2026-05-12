# Lab 05: Privilege Escalation Investigation

**Difficulty:** Beginner ⭐  
**Tools:** Linux logs, LINPEAS, GTFOBins  
**Time:** 35 minutes

## Scenario

A web server was compromised. Analyze bash history and logs to find:
1. How did attacker gain initial access?
2. What escalation technique was used?
3. What privileges were obtained?
4. What tools were downloaded?
5. Was there lateral movement?

## Files Provided

- `bash_history` - Attacker bash history
- `auth.log` - Authentication logs
- `syslog` - System events

## Step-by-Step Walkthrough

### Step 1: Examine Bash History

```bash
# Look for commands
grep -E "wget|curl|nc|python|bash" bash_history
```

### Step 2: Check Authentication Logs

```bash
# Find SSH failures/successes
grep -E "Failed|Session opened" auth.log
```

### Step 3: Identify Privilege Escalation

```bash
# Search for sudo, chmod, chown
grep -E "sudo|chmod 4777|chown" bash_history
```

### Step 4: Find Persistence

```bash
# Check for crontab, SSH keys
grep -E "crontab|.ssh/authorized_keys" bash_history
```

## Challenge Questions

| # | Question | Hint |
|---|----------|------|
| 1 | Initial access | Check auth.log for SSH brute force |
| 2 | Escalation technique | Look for sudo, SUID, kernel exploit |
| 3 | Final privileges | Whoami result, /root access |
| 4 | Tools downloaded | wget/curl commands |
| 5 | Lateral movement | Check for other hosts contacted |

## Solution

See [SOLUTION.md](SOLUTION.md)