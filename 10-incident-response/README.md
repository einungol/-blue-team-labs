# Lab 10: Incident Response Playbook

**Difficulty:** Beginner ⭐  
**Tools:** Documentation, Playbook Template  
**Time:** 30 minutes

## Scenario

Your company experienced a phishing attack. Several users clicked a malicious link. Create an incident response playbook.

### Questions:
1. What is the initial response steps?
2. How do you contain the threat?
3. How do you eradicate?
4. How do you recover?
5. What are the lessons learned?

## Step-by-Step Walkthrough

### Step 1: Detection & Analysis
```
1. Verify the report
2. Identify affected users
3. Analyze the malicious URL
4. Check for indicators
```

### Step 2: Containment
```
1. Block malicious URL/domain
2. Reset affected user passwords
3. Quarantine email
4. Isolate affected endpoints (if needed)
```

### Step 3: Eradication
```
1. Remove malware (if present)
2. Close vulnerabilities
3. Patch systems
4. Update security controls
```

### Step 4: Recovery
```
1. Restore normal operations
2. Monitor for reinfection
3. Verify clean systems
4. Return to business
```

### Step 5: Lessons Learned
```
1. Document timeline
2. Identify gaps
3. Update procedures
4. Train users
```

## Challenge Questions

| # | Question | Expected Answer |
|---|----------|-----------------|
| 1 | Initial steps | Verify → Analyze → Scope |
| 2 | Containment | Block URL, reset passwords |
| 3 | Eradication | Remove malware, patch |
| 4 | Recovery | Restore, monitor |
| 5 | Lessons learned | Document, train |

## Template

See [INCIDENT_TEMPLATE.md](INCIDENT_TEMPLATE.md)