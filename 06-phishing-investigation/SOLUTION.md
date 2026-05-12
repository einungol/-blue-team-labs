# Lab 06: Solution

## Answers

| # | Answer |
|---|--------|
| 1 | **Yes - Phishing** |
| 2 | **Nigeria (IP: 41.223.119.xx)** |
| 3 | **hxxps://secure-bank-login[.]xyz/verify** |
| 4 | **Block domain, quarantine email, reset user passwords** |
| 5 | **5 other recipients in organization** |

## Email Analysis

### Header Summary
```
From: "IT Support" <support@company-update[.]xyz>
To: employee@company.com
Subject: URGENT: Your password expires in 24 hours
Return-Path: <bounce@mail-server.ng>
```

### Authentication
| Check | Result |
|-------|--------|
| SPF | ❌ FAIL (not authorized) |
| DKIM | ❌ FAIL (invalid signature) |
| DMARC | ❌ FAIL (policy none) |

## Malicious URL

```
URL: hxxps://secure-bank-login[.]xyz/verify
Domain: secure-bank-login[.]xyz
Registrar: NameCheap
Created: 2024-03-10 (3 days ago)
Hosting: Nigeria
VT Score: 65/100 (malicious)
```

## Red Flags

1. **Urgency** - "24 hours" pressure
2. **Generic greeting** - No personalized name
3. **Suspicious sender** - External domain
4. **URL mismatch** - Bank URL doesn't match sender
5. **No training** - IT wouldn't ask this way

## Response Actions

### Immediate (0-1 hour)
- [x] Quarantine email
- [x] Block sender domain
- [x] Alert all recipients
- [ ] Reset clicked user passwords

### Short-term (24-48 hours)
- [ ] Update email filters
- [ ] Send organization-wide warning
- [ ] Document incident

### Long-term
- [ ] Implement DMARC
- [ ] Security awareness training
- [ ] URL sandboxing