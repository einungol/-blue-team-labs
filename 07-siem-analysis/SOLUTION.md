# Lab 07: Solution

## Answers

| # | Answer |
|---|--------|
| 1 | **192.168.1.200** |
| 2 | **admin@company.com** |
| 3 | **12 failed attempts** |
| 4 | **2024-03-20 09:45:23** |
| 5 | **Attack - Credential Stuffing** |

## Analysis

### Failed Login Pattern
```
Time: 2024-03-20 09:30:15 - IP: 192.168.1.200 - User: admin@company.com - Status: FAIL
Time: 2024-03-20 09:30:45 - IP: 192.168.1.200 - User: admin@company.com - Status: FAIL
... (12 total failures)
Time: 2024-03-20 09:45:23 - IP: 192.168.1.200 - User: admin@company.com - Status: SUCCESS
```

### Indicators of Attack

| Indicator | Value | Assessment |
|-----------|-------|------------|
| Failed Count | 12 | High - normal is 1-2 |
| Time Gap | ~15 min | Credential stuffing pattern |
| IP Location | VPN exit node | Anonymized |
| Username | Admin account | High value target |

## SPL Queries Used

```spl
# Find all failures for admin user
index=security action=failure user=admin* | stats count by src_ip

# Timeline of events
index=security user=admin* | bin _time span=5m | stats count by _time, action

# Correlate failure to success
index=security user=admin* src_ip=192.168.1.200 | sort _time
```

## Recommendations

1. **Block IP** at firewall/WAF
2. **Reset password** for affected account
3. **Enable MFA** if not already
4. **Document** in incident tracker
5. **Hunt** for other compromised accounts