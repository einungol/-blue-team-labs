# Lab 12: Solution

## Answers

| # | Answer |
|---|--------|
| 1 | **CreateVolume, AttachVolume, RunInstances** |
| 2 | **IAM User: admin@company** |
| 3 | **203.0.113.45 (never seen before)** |
| 4 | **Unauthorized - unusual IP, unusual time (2AM)** |
| 5 | **Disable access key, block IP, rotate credentials** |

## CloudTrail Analysis

### Suspicious Activity Timeline

| Time | Event | User | IP | Assessment |
|------|-------|------|-----|------------|
| 02:00 | ConsoleLogin | admin@company | 203.0.113.45 | ⚠️ Unusual time |
| 02:05 | CreateVolume | admin@company | 203.0.113.45 | ⚠️ New action |
| 02:10 | AttachVolume | admin@company | 203.0.113.45 | ⚠️ New action |
| 02:15 | RunInstances | admin@company | 203.0.113.45 | ⚠️ New action |

### Normal vs Suspicious

| Indicator | Normal | Suspicious |
|-----------|--------|------------|
| Login IP | Office IP | New IP |
| Login Time | Business hours | 2AM |
| Actions | Read-only | Write/Create |
| Frequency | Few/day | 10+ in 15 min |

## Investigation Steps

1. **Identify**: Find all events from this IP
2. **Scope**: Check for data exfiltration
3. **Contain**: Disable compromised credentials
4. **Remediate**: Block suspicious IP
5. **Harden**: Enable MFA, review IAM policies

## AWS Security Best Practices

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Deny",
    "Action": ["*"],
    "Resource": ["*"],
    "Condition": {
      "IpNotEquals": {"aws:SourceIp": [" office-ip/32"]}
    }
  }]
}
```

## Mitigation

1. **Enable MFA** on root and all IAM users
2. **Use IAM roles** instead of long-term keys
3. **Enable GuardDuty** for continuous monitoring
4. **Enable CloudTrail** in all regions
5. **Review** security group rules weekly