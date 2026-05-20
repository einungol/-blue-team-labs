# Lab 12: Cloud Security - AWS

**Difficulty:** Beginner ⭐  
**Tools:** AWS Console, CloudTrail, GuardDuty  
**Time:** 40 minutes

## Scenario

A company uses AWS. You notice unusual API activity in CloudTrail. Investigate.

### Questions:
1. What is the suspicious API call?
2. Which IAM user/role made the call?
3. From which IP address?
4. Is this normal behavior?
5. Recommended action?

## Step-by-Step Walkthrough

### Step 1: Review CloudTrail

```bash
# Look for unusual API calls
aws cloudtrail lookup-events --lookup-attributes attributeKey=EventSource,attributeValue=ec2.amazonaws.com
```

### Step 2: Check for Unauthorized Access

| Check | Command |
|-------|---------|
| Failed logins | `grep "errorCode" cloudtrail.json` |
| New IAM users | `grep "CreateUser" cloudtrail.json` |
| Security group changes | `grep "AuthorizeSecurityGroupIngress"` |

### Step 3: Identify Source

```
eventTime: 2024-03-20T10:30:00Z
eventName: CreateVolume
userIdentity:
  type: IAMUser
  userName: admin@company
sourceIPAddress: 203.0.113.45
```

## Challenge Questions

| # | Question | Expected Answer |
|---|----------|-----------------|
| 1 | API Call | CreateVolume, AttachVolume |
| 2 | User | admin@company |
| 3 | IP | 203.0.113.45 (suspicious) |
| 4 | Assessment | Unauthorized - new IP, unusual time |
| 5 | Action | Disable key, block IP, investigate |

## Solution

See [SOLUTION.md](SOLUTION.md)