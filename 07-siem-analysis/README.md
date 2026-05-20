# Lab 07: SIEM Analysis with Splunk

**Difficulty:** Beginner ⭐  
**Tools:** Splunk, Search Processing Language (SPL)  
**Time:** 45 minutes

## Scenario

A SOC analyst received an alert about suspicious login activity. Your task is to investigate using SIEM logs.

### Questions:
1. What is the source IP of the suspicious login?
2. Which account was targeted?
3. How many failed attempts before success?
4. What time did the successful login occur?
5. Is this a legitimate login or attack?

## Files Provided

- `splunk_logs.json` - Sample Splunk search results

## Step-by-Step Walkthrough

### Step 1: Search for Failed Logins

```spl
index=security action=failure | stats count by src_ip, user
```

### Step 2: Find Successful Login After Failures

```spl
index=security action=success | where previous_failure_time > -5m
```

### Step 3: Analyze Login Pattern

Look for:
- Multiple failures from same IP
- Time between failures
- Account targeting pattern

## Challenge Questions

| # | Question | Hint |
|---|----------|------|
| 1 | Source IP | Check src_ip field in failures |
| 2 | Target Account | Look at user field |
| 3 | Failed Count | Count events before success |
| 4 | Success Time | Find first success event |
| 5 | Assessment | Compare to normal behavior |

## Solution

See [SOLUTION.md](SOLUTION.md)