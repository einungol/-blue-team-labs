# Lab 14: Solution

## Answers

| # | Answer |
|---|--------|
| 1 | **Use sigmac command line tool** |
| 2 | **Count EventID 4625 > threshold (e.g., 10) in 5 min window** |
| 3 | **Add filter list for known IPs, exclude service accounts** |
| 4 | **Test on historical logs, tune based on results** |
| 5 | **When count exceeds threshold (10 failures in 5 min)** |

## Sigma Rule - Brute Force Detection

```yaml
title: RDP Brute Force Detection
id: 5c3a8d12-1234-5678-9abc-def012345678
status: stable
description: Detects possible RDP brute force attack
author: Blue Team Labs
date: 2024-03-20
tags:
  - attack.credential_access
  - attack.t1110
logsource:
  product: windows
  service: security
detection:
  selection:
    EventID: 4625
    LogonType: 10
  timeframe: 5m
  condition: selection | count(src_ip) by target_user > 10
fields:
  - target_user_name
  - ip_address
  - logon_type
falsepositives:
  - User typos password multiple times
level: high
```

## Converted Queries

### Splunk
```spl
index=security EventID=4625 LogonType=10
| stats count by src_ip, target_user_name
| where count > 10
```

### ELK (Lucene)
```
EventID:4625 AND LogonType:10
| terms target_user_name by src_ip
| filter count > 10
```

### QRadar (AQL)
```sql
SELECT src_ip, target_user_name, COUNT(*) as fail_count
FROM events
WHERE EventID=4625 AND LogonType=10
GROUP BY src_ip, target_user_name
HAVING COUNT(*) > 10
WITHIN 5 MINUTES
```

## Testing the Rule

### Step 1: Generate Test Data
```bash
# Create 15 failed logins from same IP
for i in {1..15}; do
  echo "EventID=4625, IP=192.168.1.100, User=admin" >> test.log
done
```

### Step 2: Run Query
```bash
splunk search "$(cat converted_query.spl)"
# Should return: IP 192.168.1.100 with count 15
```

### Step 3: Verify Alert
```
✅ Rule triggers when count > 10
✅ Rule does NOT trigger for count < 10
✅ False positives filtered (legitimate users)
```

## Handling False Positives

| FP Scenario | Mitigation |
|-------------|------------|
| User typos | Add time window, only trigger after multiple |
| Service account | Exclude known service accounts |
| Known VPN IPs | Create allowlist |
| Admin testing | Exclude admin test accounts |

## Deployment

### Tools to Use
- **sigmac** - Command line converter
- [uncoder.io](https://uncoder.io) - Online converter
- Sigma CLI - Modern Python tool

### Integration
| SIEM | Method |
|------|--------|
| Splunk | Import as saved search |
| ELK | Create detection rule |
| QRadar | Add to offense rules |
| Microsoft Sentinel | Import as analytics rule |