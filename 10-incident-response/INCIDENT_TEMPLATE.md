# Incident Response Playbook Template

## 📋 Phishing Incident Response

### Incident ID: [ID-0000]
### Date: [YYYY-MM-DD]
### Severity: [Critical/High/Medium/Low]
### Status: [Open/In Progress/Closed]

---

## Phase 1: Detection & Analysis

### Initial Report
| Field | Value |
|-------|-------|
| Reported By | [Name] |
| Report Time | [Timestamp] |
| Attack Vector | Phishing Email |
| Affected Users | [Count] |

### IOCs Identified
```
Malicious URL: [URL]
Malicious Domain: [Domain]
Suspicious IP: [IP]
Email Subject: [Subject]
Sender: [Email Address]
```

---

## Phase 2: Containment

### Immediate Actions (0-1 hour)
- [ ] Block malicious URL/domain at proxy/firewall
- [ ] Block sender email domain
- [ ] Quarantine malicious email from mail server
- [ ] Reset passwords for affected users
- [ ] Disable compromised accounts (if identified)
- [ ] Isolate affected endpoints (if malware present)

### Extended Containment (1-24 hours)
- [ ] Check logs for other affected users
- [ ] Review proxy logs for C2 traffic
- [ ] Verify MFA was enabled on affected accounts
- [ ] Block related IOCs

---

## Phase 3: Eradication

### Cleanup Actions
- [ ] Remove malware from affected endpoints
- [ ] Re-image compromised systems (if needed)
- [ ] Patch exploited vulnerabilities
- [ ] Update email security filters
- [ ] Update proxy/firewall block lists

### Verification
- [ ] Confirm all malicious indicators removed
- [ ] Verify no new infections
- [ ] Confirm systems are clean

---

## Phase 4: Recovery

### Restoration
- [ ] Restore normal business operations
- [ ] Enable affected accounts (with new passwords)
- [ ] Monitor for reinfection
- [ ] Verify all services operational

### Post-Recovery Monitoring (30 days)
- [ ] Daily log review for 7 days
- [ ] Weekly IOC sweep for 30 days
- [ ] User awareness monitoring

---

## Phase 5: Lessons Learned

### Timeline
| Time | Event |
|------|-------|
| T+0 | Email received by users |
| T+1h | Incident reported |
| T+2h | Containment complete |
| T+24h | Eradication complete |
| T+48h | Recovery complete |

### Root Cause
[Description of how attack succeeded]

### Gaps Identified
1. [Gap 1]
2. [Gap 2]
3. [Gap 3]

### Recommendations
1. [Recommendation 1]
2. [Recommendation 2]
3. [Recommendation 3]

### Action Items
| Item | Owner | Due Date |
|------|-------|----------|
| Update email filtering | | |
| User awareness training | | |
| Implement additional controls | | |

---

## Sign-off

| Role | Name | Date |
|------|------|------|
| Incident Lead | | |
| Security Manager | | |
| IT Operations | | |