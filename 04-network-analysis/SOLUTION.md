# Lab 04: Solution

## Answers

| # | Answer |
|---|--------|
| 1 | **DNS tunneling (DNS query abuse)** |
| 2 | **Yes - periodic beacons to dns.evil[.]xyz** |
| 3 | **Credential theft via DNS TXT queries** |
| 4 | **dns.evil[.]xyz, data.malware[.]net** |
| 5 | **192.168.1.101 (workstation)** |

## Traffic Summary

| Metric | Value |
|--------|-------|
| Total packets | 15,234 |
| DNS queries | 4,521 |
| HTTP requests | 892 |
| Unique IPs | 12 |

## Suspicious Activity

### DNS Tunneling
```
Query: "a1b2c3d4e5f6g7h8.evil.xyz"
Query: "payload.data.evil.xyz"  
Query: "exfil.12345.evil.xyz"
```

Pattern: Long subdomain strings, base64 encoding in queries

### C2 Beacon
```
Interval: 60 seconds
Size: ~150 bytes
Pattern: GET /api/v1/heartbeat
```

### Data Exfiltration
```
Destination: 185.243.115.84:53
Data: NTLM hash in DNS TXT queries
Volume: ~2MB over 30 minutes
```

## IOCs

| Type | Value |
|------|-------|
| C2 Domain | dns.evil[.]xyz |
| C2 IP | 185.243.115.84 |
| Victim | 192.168.1.101 |
| Exfil Data | Domain credentials |

## Detection Rules

### Suricata
```yaml
alert dns any any -> any 53 (dns.query; regex:^[a-zA-Z0-9]{50,}\.evil; msg:"Potential DNS Tunneling"; sid:100001;)
```

### Zeek
```zeek
event dns_message(c: connection, msg: dns_msg)
{
    if (|msg/query| > 50) {
        NOTICE([$msg="Suspicious DNS query", $c=c]);
    }
}
```

## Mitigation

1. Block DNS tunneling at firewall
2. Limit DNS response size
3. Enable DNS logging
4. Implement DNS sinkhole