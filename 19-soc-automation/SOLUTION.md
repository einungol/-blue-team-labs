# Lab 19: SOC Automation (SOAR) - Solution

## Answers to Challenge Questions

### Question 1: How to create an alert triage workflow?
**Answer:**

```
┌─────────────────────────────────────────────────────────────────┐
│                    Alert Triage Workflow                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────┐                                                   │
│  │  Alert   │                                                   │
│  │ Received │                                                   │
│  └────┬─────┘                                                   │
│       │                                                          │
│       ▼                                                          │
│  ┌──────────────────────────────────┐                          │
│  │      Enrichment Stage            │                          │
│  │  - VirusTotal (IP, Hash, Domain) │                          │
│  │  - AbuseIPDB (IP Reputation)    │                          │
│  │  - OTX (Threat Intel)           │                          │
│  └──────────────┬───────────────────┘                          │
│                 │                                                │
│                 ▼                                                │
│  ┌──────────────────────────────────┐                          │
│  │      Triage Decision             │                          │
│  │                                  │                          │
│  │  Score ≥ 70 = HIGH              │                          │
│  │  Score 40-69 = MEDIUM           │                          │
│  │  Score < 40 = LOW               │                          │
│  └──────────────┬───────────────────┘                          │
│                 │                                                │
│      ┌──────────┼──────────┐                                    │
│      ▼          ▼          ▼                                    │
│  ┌──────┐  ┌──────┐  ┌──────┐                                   │
│  │ HIGH │  │MEDIUM│  │ LOW  │                                   │
│  └──┬───┘  └──┬───┘  └──┬───┘                                   │
│     │         │         │                                       │
│     ▼         ▼         ▼                                       │
│  ┌──────┐  ┌──────┐  ┌──────┐                                  │
│  │ Case │  │ Case │  │Auto  │                                  │
│  │Create│  │Create│  │Close │                                  │
│  └──────┘  └──────┘  └──────┘                                  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Implementation in n8n:**
```javascript
// Triage Logic Node
if (enrichment.malicious_score >= 70) {
  status = "high";
  action = "create_case";
} else if (enrichment.malicious_score >= 40) {
  status = "medium";
  action = "create_case";
} else {
  status = "low";
  action = "auto_close";
}
```

---

### Question 2: How to automatically enrich alerts with threat intelligence?
**Answer:**

**VirusTotal Integration:**
```javascript
{
  "node": "HTTP Request",
  "name": "VirusTotal Enrichment",
  "parameters": {
    "url": "https://www.virustotal.com/api/v3/ip_addresses/{{$json.alert_ip}}",
    "method": "GET",
    "authentication": {
      "type": "genericCredentialType",
      "genericAuthType": "httpHeaderAuth"
    }
  }
}
```

**AbuseIPDB Integration:**
```javascript
{
  "node": "HTTP Request",
  "name": "AbuseIPDB Check",
  "parameters": {
    "url": "https://api.abuseipdb.com/api/v2/check",
    "method": "POST",
    "body": {
      "ipAddress": "{{$json.alert_ip}}",
      "maxAgeInDays": 90
    }
  }
}
```

**Enrichment Response:**
```json
{
  "enrichment": {
    "virustotal": {
      "malicious": 15,
      "suspicious": 3,
      "categories": ["malware", "phishing"]
    },
    "abuseipdb": {
      "abuseConfidenceScore": 85,
      "isWhitelisted": false,
      "reports": 234
    }
  },
  "final_score": 78,
  "decision": "high"
}
```

---

### Question 3: How to create automated response actions?
**Answer:**

**1. Block IP at Firewall:**
```javascript
{
  "node": "HTTP Request",
  "name": "Block IP at Firewall",
  "parameters": {
    "url": "https://firewall.company.com/api/block",
    "method": "POST",
    "body": {
      "ip": "{{$json.alert_ip}}",
      "reason": "{{$json.alert_name}}",
      "duration": "24h",
      "addedBy": "SOAR Automation"
    }
  }
}
```

**2. Disable User Account:**
```javascript
{
  "node": "HTTP Request",
  "name": "Disable Compromised User",
  "parameters": {
    "url": "https://ad.company.com/api/disable-user",
    "method": "POST",
    "body": {
      "username": "{{$json.alert_username}}",
      "reason": "Compromise detected - automated response"
    }
  }
}
```

**3. Send to TheHive (Case Management):**
```javascript
{
  "node": "TheHive",
  "name": "Create Case",
  "parameters": {
    "operation": "createCase",
    "title": "Alert: {{$json.alert_name}}",
    "severity": 2,
    "tags": ["automated", "{{$json.alert_type}}"],
    "description": "Alert triggered at {{$json.timestamp}}"
  }
}
```

---

### Question 4: How to handle false positives?
**Answer:**

**Whitelist Implementation:**
```javascript
// Whitelist configuration
const ipWhitelist = [
  "10.0.0.1",   // Company Proxy
  "10.0.0.2",   // Load Balancer
  "8.8.8.8",    // Google DNS
  "1.1.1.1"     // Cloudflare DNS
];

const userWhitelist = [
  "service_account",
  "system_admin",
  "backup_service"
];

// False positive detection
function checkFalsePositive(alert) {
  // Check IP whitelist
  if (ipWhitelist.includes(alert.ip)) {
    return {
      "is_fp": true,
      "reason": "IP in whitelist"
    };
  }
  
  // Check user whitelist
  if (userWhitelist.includes(alert.username)) {
    return {
      "is_fp": true,
      "reason": "Service account"
    };
  }
  
  // Check known good patterns
  if (alert.action === "failed_login" && alert.count < 5) {
    return {
      "is_fp": true,
      "reason": "Below threshold"
    };
  }
  
  return { "is_fp": false };
}
```

**Auto-Close Low Risk:**
```javascript
// Close false positives automatically
if (checkFalsePositive(alert).is_fp) {
  // Add to case notes
  // Tag as false positive
  // Close alert
  // Send summary to analyst
}
```

---

### Question 5: How to measure automation effectiveness?
**Answer:**

**Key Metrics:**

| Metric | Formula | Target |
|--------|---------|--------|
| MTTD | Avg time from alert to detection | < 5 min |
| MTTR | Avg time from detection to response | < 15 min |
| Automation Rate | Alerts auto-processed / Total | > 70% |
| False Positive Rate | Auto-closed / Total Auto | < 30% |
| Case Volume | Cases created per day | Monitor |

**Dashboard Queries:**
```javascript
// MTTR calculation
{
  "aggs": {
    "avg_response_time": {
      "avg": {
        "field": "response_time_minutes"
      }
    }
  }
}

// Automation coverage
{
  "aggs": {
    "auto_processed": {
      "terms": {
        "field": "processing_type",
        "size": 10
      }
    }
  }
}
```

**Example Dashboard:**
```
+-------------------------+--------+
| Metric                  | Value  |
+-------------------------+--------+
| Total Alerts (24h)      | 1,247  |
| Auto-Processed          | 892    |
| Automation Rate         | 71.5%  |
| MTTD (min)             | 2.3    |
| MTTR (min)             | 8.7    |
| False Positives         | 156    |
| Cases Created          | 312    |
+-------------------------+--------+
```

---

## Workflow Implementation Example

### Complete n8n Workflow JSON (Simplified)
```json
{
  "name": "SOC Alert Triage",
  "nodes": [
    {
      "name": "Webhook Trigger",
      "type": "n8n-nodes-base.webhook",
      "parameters": { "path": "soc-alert" }
    },
    {
      "name": "Enrich with VirusTotal",
      "type": "n8n-nodes-base.httpRequest"
    },
    {
      "name": "Enrich with AbuseIPDB",
      "type": "n8n-nodes-base.httpRequest"
    },
    {
      "name": "Calculate Score",
      "type": "n8n-nodes-base.code",
      "code": "score = (vt.malicious * 2) + (abuse.score)"
    },
    {
      "name": "Triage Decision",
      "type": "n8n-nodes-base.if",
      "parameters": { "value1": "{{score}}", "operation": ">=", "value2": 70 }
    },
    {
      "name": "Create TheHive Case",
      "type": "n8n-nodes-base.httpRequest",
      "parameters": { "condition": true }
    },
    {
      "name": "Auto Close Low",
      "type": "n8n-nodes-base.noOp",
      "parameters": { "condition": false }
    }
  ]
}
```

---

## Security Considerations

1. **Credential Management**
   - Use secure credential storage
   - Rotate API keys regularly
   - Implement least privilege

2. **Rate Limiting**
   - Respect API rate limits
   - Implement caching
   - Queue requests if needed

3. **Audit Logging**
   - Log all automated actions
   - Keep audit trail
   - Alert on failures

4. **Approval Workflows**
   - Require approval for destructive actions
   - Manual approval for high-severity
   - Auto-approve only for low-risk

---

## References

- [n8n Documentation](https://docs.n8n.io/)
- [TheHive API](https://docs.thehive-project.org/)
- [SOAR Best Practices](https://www.sans.org/reading-room/whitepapers/analyst/building-security-automation-response-402)

---

**Back to:** [README.md](README.md)