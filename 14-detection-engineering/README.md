# Lab 14: Detection Engineering with Sigma Rules

**Difficulty:** Beginner ⭐  
**Tools:** Sigma, Splunk, QRadar  
**Time:** 40 minutes

## Scenario

You need to create detection rules for common attack techniques using Sigma format.

### Questions:
1. How do you convert Sigma to Splunk/SQL?
2. What detection logic is needed for brute force?
3. How do you handle false positives?
4. How do you test the rule?
5. When should the rule fire?

## Step-by-Step Walkthrough

### Step 1: Understand Sigma Format

```yaml
title: Detect Failed Login
status: experimental
logsource:
  product: windows
  service: security
detection:
  selection:
    EventID: 4625
  condition: selection
```

### Step 2: Write Detection Rule

```yaml
title: Detect Brute Force Attack
status: stable
logsource:
  product: windows
  service: security
detection:
  selection:
    EventID: 4625
    LogonType: 10
  timeframe: 5m
  condition: selection | count() by IpAddress > 10
level: high
```

### Step 3: Convert to SIEM

```bash
# Use sigmac to convert
sigmac --target splunk rules/brute_force.yml

# Output
index=security EventID=4625 LogonType=10
| stats count by IpAddress
| where count > 10
```

## Challenge Questions

| # | Question | Expected Answer |
|---|----------|-----------------|
| 1 | Conversion | Use sigmac tool |
| 2 | Detection logic | Count failures > threshold in time window |
| 3 | False positives | Add filters, exclude known IPs |
| 4 | Testing | Test on real logs |
| 5 | When to fire | When threshold exceeded |

## Solution

See [SOLUTION.md](SOLUTION.md)