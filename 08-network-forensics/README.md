# Lab 08: Network Forensics with Wireshark

**Difficulty:** Beginner ⭐  
**Tools:** Wireshark, tshark  
**Time:** 40 minutes

## Scenario

A user reported slow network performance. A packet capture was taken from their workstation. Analyze to find the issue.

### Questions:
1. What protocol is causing high traffic?
2. Is there any malicious communication?
3. Are credentials being transmitted in plain text?
4. What is the suspicious domain contacted?
5. Recommended action?

## Files Provided

- `capture.pcap` - Network capture file

## Step-by-Step Walkthrough

### Step 1: View Protocol Hierarchy

```bash
# In Wireshark: Statistics > Protocol Hierarchy
# Or via tshark:
tshark -r capture.pcap -q -z io,phs
```

### Step 2: Find Top Talkers

```bash
tshark -r capture.pcap -q -z conv,tcp | head -20
```

### Step 3: Check for Cleartext Credentials

```bash
# Look for HTTP basic auth
tshark -r capture.pcap -Y "http.authbasic" -T fields -e http.authbasic

# Look for FTP credentials
tshark -r capture.pcap -Y "ftp.request.command == USER" -T fields -e ftp.request.parameter
```

### Step 4: Extract DNS Queries

```bash
tshark -r capture.pcap -Y "dns.qry.name" -T fields -e dns.qry.name | sort | uniq -c | sort -rn
```

## Challenge Questions

| # | Question | Hint |
|---|----------|------|
| 1 | High Traffic Protocol | Check Protocol Hierarchy |
| 2 | Malicious Traffic | Look for non-business protocols |
| 3 | Plaintext Creds | Search for auth in plain text |
| 4 | Suspicious Domain | Check DNS queries |
| 5 | Action | Isolate, block, investigate |

## Solution

See [SOLUTION.md](SOLUTION.md)