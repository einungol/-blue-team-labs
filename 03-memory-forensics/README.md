# Lab 03: Memory Forensics

**Difficulty:** Beginner ⭐  
**Tools:** Volatility3, Rekall, WinPmem  
**Time:** 45 minutes

## Scenario

A workstation was suspected of being compromised. A memory dump was captured. Analyze to find:
1. What processes were running?
2. Any suspicious processes?
3. Network connections at time of capture?
4. Hidden/rootkit processes?
5. Credentials in memory?

## Files Provided

- `memory.raw` - Memory dump file (sample)
- `profile.json` - System info

## Step-by-Step Walkthrough

### Step 1: Identify OS Profile

```bash
# Get image info
vol -f memory.raw windows.info
```

### Step 2: List Processes

```bash
# List all processes
vol -f memory.raw windows.pslist
```

### Step 3: Check Hidden Processes

```bash
# Find hidden processes (DKOM attack)
vol -f memory.raw windows.psscan
```

### Step 4: Network Connections

```bash
# Active connections
vol -f memory.raw windows.netscan
```

### Step 5: Dump Suspicious Process

```bash
# Extract suspicious process memory
vol -f memory.raw -o output/ windows.procdump --pid 1234
```

## Challenge Questions

| # | Question | Hint |
|---|----------|------|
| 1 | Running processes | Use pslist |
| 2 | Suspicious process | Look for hidden/mismatched |
| 3 | Network connections | netscan shows active |
| 4 | Rootkit indicators | psscan vs pslist diff |
| 5 | Credentials | Use lsass dump |

## Solution

See [SOLUTION.md](SOLUTION.md)