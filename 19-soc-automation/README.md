# Lab 19: SOC Automation (SOAR)

**Difficulty:** Intermediate ⭐⭐  
**Tools:** n8n, Shuffle, TheHive, Cortex  
**Time:** 50 minutes

## Scenario

Your SOC receives hundreds of alerts daily. Create an automation workflow to automatically triage and respond to common alerts.

### Questions:
1. How to create an alert triage workflow?
2. How to automatically enrich alerts with threat intelligence?
3. How to create automated response actions?
4. How to handle false positives?
5. How to measure automation effectiveness?

## Prerequisites

### Knowledge Required
- Basic understanding of SOC operations
- Knowledge of SIEM and alert processing
- Familiarity with API integrations

### Tools Needed
- [n8n](https://n8n.io/) - Workflow automation (free, self-hosted)
- [Shuffle](https://shuffler.io/) - SOAR platform
- [TheHive](https://thehive-project.org/) - Incident response
- [Cortex](https://thehive-project.org/cortex/) - Threat intelligence analysis

### Pre-Reading (Optional)
- [n8n Documentation](https://docs.n8n.io/)
- [SOAR Fundamentals](https://www.sans.org/reading-room/whitepapers/analyst/building-security-automation-response-402)

---

## Step-by-Step Walkthrough

### Step 1: Design Alert Triage Workflow

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Alert     │───▶│   Enrich    │───▶│   Triage    │
│   Trigger   │    │   (VT, OTX) │    │   Decision  │
└─────────────┘    └─────────────┘    └─────────────┘
                                              │
                      ┌───────────────────────┼───────────────────────┐
                      ▼                       ▼                       ▼
               ┌─────────────┐         ┌─────────────┐         ┌─────────────┐
               │   High      │         │   Medium    │         │    Low      │
               │   Severity  │         │   Severity  │         │   Severity  │
               └─────────────┘         └─────────────┘         └─────────────┘
                      │                       │                       │
                      ▼                       ▼                       ▼
               ┌─────────────┐         ┌─────────────┐         ┌─────────────┐
               │   Create    │         │   Create    │         │   Auto      │
               │   Case      │         │   Case      │         │   Close     │
               └─────────────┘         └─────────────┘         └─────────────┘
```

### Step 2: Create n8n Workflow

```javascript
// n8n workflow structure
{
  "nodes": [
    {
      "name": "Splunk Webhook",
      "type": "n8n-nodes-base.webhook",
      "parameters": {
        "path": "soc-alert"
      }
    },
    {
      "name": "VirusTotal Enrichment",
      "type": "n8n-nodes-base.httpRequest",
      "parameters": {
        "method": "GET",
        "url": "https://www.virustotal.com/api/v3/ip_addresses/{{$json.ip}}",
        "authentication": "genericCredentialType",
        "genericAuthType": "httpHeaderAuth"
      }
    },
    {
      "name": "Create TheHive Case",
      "type": "n8n-nodes-base.httpRequest",
      "method": "POST"
    }
  ]
}
```

### Step 3: Configure Threat Intelligence Enrichment

```javascript
// VirusTotal enrichment node
{
  "url": "https://www.virustotal.com/api/v3/files/{{hash}}",
  "method": "GET",
  "authentication": {
    "type": "genericCredentialType",
    "genericAuthType": "httpHeaderAuth"
  }
}

// Use enrichment data in triage
if (enrichment.data.last_analysis_stats.malicious > 5) {
  severity = "high";
}
```

### Step 4: Create Automated Response Actions

```javascript
// Block IP at firewall (example)
{
  "node": "HTTP Request",
  "url": "https://firewall/api/block",
  "method": "POST",
  "body": {
    "ip": "{{alert.ip}}",
    "reason": "{{alert.alert_name}}",
    "duration": "24h"
  }
}

// Disable user account (example)
{
  "node": "HTTP Request",
  "url": "https://ad-server/api/disable-user",
  "method": "POST",
  "body": {
    "username": "{{alert.username}}"
  }
}
```

### Step 5: Handle False Positives

```javascript
// Whitelist known IPs
const whitelist = [
  "10.0.0.1",  // proxy
  "10.0.0.2",  // load balancer
  "8.8.8.8"    // DNS
];

if (whitelist.includes(alert.ip)) {
  // Close as false positive
  status = "closed";
  reason = "whitelisted";
}
```

## Challenge Questions

| # | Question | Answer |
|---|----------|--------|
| 1 | Triage workflow | Use conditional nodes based on severity |
| 2 | Threat intel | Use VT API for IP/file/hash enrichment |
| 3 | Auto response | HTTP requests to block IPs, disable users |
| 4 | False positives | Maintain whitelist, auto-close low-risk |
| 5 | Measurement | Track: alerts processed, response time, false positive rate |

## Solution

See [SOLUTION.md](SOLUTION.md)

---

## Common Automation Patterns

| Pattern | Description | Tools |
|---------|-------------|-------|
| Alert Enrichment | Add threat intel to alerts | VirusTotal, OTX, AbuseIPDB |
| Auto-Triage | Sort alerts by severity | n8n, Shuffle |
| Case Creation | Auto-create cases in TheHive | TheHive API |
| Response Actions | Block IPs, disable users | Firewall API, AD |
| Notification | Alert SOC team | Slack, PagerDuty, Email |

---

## Metrics to Track

- **MTTD** - Mean Time to Detect
- **MTTR** - Mean Time to Respond
- **False Positive Rate** - % of alerts that are FP
- **Automation Coverage** - % of alerts auto-processed
- **Case Volume** - Cases created per day

---

## Security Considerations

- Secure API credentials
- Rate limiting on external APIs
- Audit logging for all actions
- Approval workflows for destructive actions

---

**Back to:** [Main README](../README.md)