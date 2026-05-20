# Lab 08: Solution

## Answers

| # | Answer |
|---|--------|
| 1 | **HTTP + DNS** |
| 2 | **Yes - Suspicious DNS queries** |
| 3 | **No - All encrypted** |
| 4 | **update.malware-c2[.]xyz** |
| 5 | **Isolate host, block domain, investigate** |

## Traffic Analysis

### Protocol Distribution
| Protocol | Packets | Percentage |
|----------|---------|------------|
| DNS | 15,234 | 45% |
| HTTP | 8,921 | 26% |
| TLS | 6,234 | 18% |
| Other | 3,521 | 11% |

### Suspicious DNS Queries
```
query: api.analytics.svc.local          (Legitimate)
query: update.malware-c2.xyz            (SUSPICIOUS)
query: stats.malware-c2.xyz             (SUSPICIOUS)
query: cdn.content delivery.net         (Legitimate)
```

### IOCs Found

| Type | Value |
|------|-------|
| Malicious Domain | update.malware-c2.xyz |
| C2 IP | 185.243.115.84 |
| Protocol | DNS Tunneling |
| Payload Size | ~50KB in 24 hours |

## Investigation Steps

1. **Isolate** - Disconnect from network immediately
2. **Capture** - Full memory dump + disk image
3. **Analyze** - Malware family identification
4. **Scope** - Check for lateral movement
5. **Remediate** - Clean rebuild recommended

## Wireshark Filters for Future

```wireshark
# Find DNS tunneling
dns.qry.name.len > 50

# Find suspicious HTTP user agents
http.user_agent matches "python|curl|wget"

# Find plaintext passwords
http.password || ftp.pass
```