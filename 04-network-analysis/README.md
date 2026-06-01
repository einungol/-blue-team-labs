# Lab 04: Network Traffic Analysis

**Difficulty:** Beginner ⭐  
**Tools:** Wireshark, Zeek, tshark  
**Time:** 40 minutes

## Prerequisites

### Knowledge Required
- Basic understanding of TCP/IP, UDP, DNS, HTTP/HTTPS
- Familiarity with packet capture concepts
- Understanding of network protocols

### Tools Needed
- [Wireshark](https://www.wireshark.org) - Network protocol analyzer
- [Zeek](https://zeek.org) - Network security monitor (optional)
- [tshark](https://www.wireshark.org/docs/man-pages/tshark.html) - Command-line Wireshark

### Pre-Reading (Optional)
- [Wireshark Tutorial for Beginners](https://www.wireshark.org/docs/)
- [Network Forensics Basics](https://www.sans.org/reading-room/whitepapers/forensics/memory-forensics-techniques-detecting-rootkits-210)

## Scenario

A network capture shows suspicious activity. Analyze to identify:
1. What protocol is being abused?
2. Is there any C2 communication?
3. Any data exfiltration?
4. Malicious domains contacted?
5. Affected hosts?

## Files Provided

- `capture.pcap` - Network capture file

## Step-by-Step Walkthrough

### Step 1: Basic Stats

```bash
# Capture summary
tshark -r capture.pcap -q -z io,phs

# Protocol hierarchy
tshark -r capture.pcap -q -z proto,colinfo
```

### Step 2: DNS Analysis

```bash
# Extract DNS queries
tshark -r capture.pcap -Y "dns.qry.name" -T fields -e dns.qry.name | sort | uniq
```

### Step 3: HTTP Traffic

```bash
# Extract HTTP requests
tshark -r capture.pcap -Y "http.request.method == GET" -T fields -e http.host -e http.request.uri
```

### Step 4: Suspicious Connections

```bash
# Find non-standard ports
tshark -r capture.pcap -Y "tcp.dstport > 1024 and not tls" -T fields -e ip.src -e ip.dst -e tcp.dstport
```

## Challenge Questions

| # | Question | Hint |
|---|----------|------|
| 1 | Abused protocol | Look for non-HTTP on port 80/443 |
| 2 | C2 indicators | Long connections, periodic beacons |
| 3 | Exfil data | Large uploads to unknown IPs |
| 4 | Domains | Check DNS for suspicious TLDs |
| 5 | Victim IP | Check first communication |

## Solution

See [SOLUTION.md](SOLUTION.md)