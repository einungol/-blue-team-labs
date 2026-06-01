# Lab 17: Syslog and Log Management - Solution

## Answers to Challenge Questions

### Question 1: What is the format of incoming logs?
**Answer:** Syslog format (RFC 5424)

**Example:**
```
<34>1 2024-03-20T09:15:22.000Z server1 sshd 1234 - Failed password for invalid user admin from 203.0.113.50 port 22 ssh2
```

| Part | Description |
|------|-------------|
| `<34>` | Priority (facility × 8 + severity) |
| `1` | Version |
| `2024-03-20T09:15:22.000Z` | Timestamp |
| `server1` | Hostname |
| `sshd` | Application |
| `1234` | Process ID |
| Message | The actual log content |

---

### Question 2: Which server is generating the most logs?
**Answer:** `web-server-01` with 45,230 logs

**Query:**
```bash
# Count logs by hostname
cat /var/log/*/*.log | awk '{print $4}' | sort | uniq -c | sort -rn
```

**In Elasticsearch/Kibana:**
```
GET /syslog/_search
{
  "size": 0,
  "aggs": {
    "by_host": {
      "terms": { "field": "host.raw" }
    }
  }
}
```

---

### Question 3: Are there any authentication failures?
**Answer:** Yes - Multiple failed SSH logins detected

**Search Pattern:**
```bash
# Search for authentication failures
grep -i "failed\|authentication failure\|invalid user" /var/log/auth.log
```

**In Kibana:**
```
host: "web-server-01" AND message: "Failed password"
```

**Details:**
- Total failures: 1,247
- Top attacking IP: 203.0.113.50 (892 attempts)
- Target users: admin, root, test, backup

---

### Question 4: Is there suspicious activity in the logs?
**Answer:** Yes - Potential data exfiltration detected

**Indicators:**
```
1. Large outbound transfer to unknown IP
   - Source: db-server-01 (10.0.1.20)
   - Destination: 185.234.219.10 (suspicious)
   - Size: 2.3GB over 30 minutes

2. Unusual cron job activity
   - Command: powershell -enc <encoded>
   - User: www-data
   - Frequency: Every 5 minutes

3. Privilege escalation attempt
   - Command: chmod 4777 /tmp/backdoor
   - Result: Failed (permission denied)
```

---

### Question 5: How to create alerts for specific events?
**Answer:** Using rsyslog filters

**Configuration:**
```bash
# /etc/rsyslog.conf

# Alert on authentication failures
if $msg contains "Failed password" then {
  action(type="omfile" file="/var/log/auth_failures.log")
  action(type="omgelf" template="json" server="elasticsearch:9200")
}

# Alert on privilege escalation
if $msg contains "chmod 4777" or $msg contains "chmod +s" then {
  action(type="omfile" file="/var/log/priv_esc.log")
  action(type="omgelf" server="elasticsearch:9200" template="json")
  stop
}

# Alert on large data transfers
if $msg contains "DATA_TRANSFER" and $msg contains "large" then {
  action(type="omfile" file="/var/log/data_exfil.log")
}
```

**Restart rsyslog:**
```bash
sudo systemctl restart rsyslog
```

---

## Step-by-Step Configuration

### Step 1: rsyslog Server Setup
```bash
# Install rsyslog
sudo apt install rsyslog rsyslog-gnutls

# Enable modules
sudo vim /etc/rsyslog.conf

# Add these lines:
module(load="imudp")
input(type="imudp" port="514")

module(load="imtcp")
input(type="imtcp" port="514")

# TLS encryption (optional)
$DefaultNetstreamDriver gtls
$ActionSendStreamDriverMode 1
$ActionSendStreamDriverAuthMode x509
```

### Step 2: Client Configuration
```bash
# On client server
sudo vim /etc/rsyslog.conf

# Add forward rule
*.* @@rsyslog-server.corp.local:514
```

### Step 3: Log Storage
```bash
# Template for separate files per host
$template RemoteLogs,"/var/log/%HOSTNAME%/%PROGRAMNAME%.log"
*.* ?RemoteLogs
```

---

## Elasticsearch Queries

### Basic Search
```json
GET /syslog/_search
{
  "query": {
    "match": { "message": "failed" }
  }
}
```

### Authentication Failures
```json
GET /syslog/_search
{
  "query": {
    "bool": {
      "must": [
        { "match": { "program": "sshd" }},
        { "match": { "message": "Failed" }}
      ]
    }
  }
}
```

### Create Alert
```json
PUT /_watcher/watch/auth-failures
{
  "trigger": { "schedule": { "interval": "5m" }},
  "condition": {
    "compare": {
      "ctx.payload.hits.total": { "gt": 10 }
    }
  },
  "actions": {
    "email": {
      "to": "soc@company.com",
      "subject": "Auth Failure Alert"
    }
  }
}
```

---

## Summary

| Metric | Value |
|--------|-------|
| Total logs received | 245,000 |
| Servers | 12 |
| Auth failures | 1,247 |
| Suspicious events | 3 |
| Alerts created | 5 |

---

**Back to:** [README.md](README.md)