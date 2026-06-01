# Lab 17: Syslog and Log Management

**Difficulty:** Beginner ⭐  
**Tools:** rsyslog, syslog-ng, Logstash, Elasticsearch  
**Time:** 40 minutes

## Scenario

Your organization needs to centralize logs from multiple Linux servers. Set up a syslog server and configure log forwarding.

### Questions:
1. What is the format of incoming logs?
2. Which server is generating the most logs?
3. Are there any authentication failures?
4. Is there suspicious activity in the logs?
5. How to create alerts for specific events?

## Prerequisites

### Knowledge Required
- Linux system administration
- Understanding of syslog protocol
- Basic networking

### Tools Needed
- [rsyslog](https://www.rsyslog.com/) - Syslog server
- [Elastic Stack](https://www.elastic.co/elastic-stack) - Log management
- [Logstash](https://www.elastic.co/logstash) - Log processing

### Pre-Reading (Optional)
- [rsyslog Configuration](https://www.rsyslog.com/doc/configuration/)
- [Syslog Protocol RFC](https://tools.ietf.org/html/rfc5424)

---

## Step-by-Step Walkthrough

### Step 1: Configure rsyslog Server

```bash
# /etc/rsyslog.conf
# Enable UDP/TCP reception
module(load="imudp")
input(type="imudp" port="514")

module(load="imtcp")
input(type="imtcp" port="514")

# Store logs
$template RemoteLogs,"/var/log/%HOSTNAME%/%PROGRAMNAME%.log"
*.* ?RemoteLogs
```

### Step 2: Configure Client Log Forwarding

```bash
# /etc/rsyslog.conf on client
*.* @@rsyslog-server:514
```

### Step 3: Parse Different Log Types

```bash
# Parse Apache logs
$template ApacheFormat,"%timestamp% %hostname% %programname% %msg%\n"
if $programname contains 'apache2' then action(type="omfile" template="ApacheFormat" file="/var/log/apache/remote.log")
```

### Step 4: Create Filters

```bash
# Alert on authentication failures
if $msg contains "Failed password" then {
  action(type="omfile" file="/var/log/auth_failures.log")
  action(type="omgelf" template="json" server="elasticsearch:9200")
}
```

### Step 5: Forward to SIEM

```bash
# Forward to Elasticsearch via Logstash
action(type="omfwd"
       target="logstash.server.com"
       port="514"
       protocol="tcp"
       template="json")
```

## Challenge Questions

| # | Question | Expected Answer |
|---|----------|-----------------|
| 1 | Log format | Syslog format with timestamp, hostname, facility, priority, message |
| 2 | Server with most logs | Use log analysis to count by hostname |
| 3 | Auth failures | Search for "Failed password" or "authentication failure" |
| 4 | Suspicious activity | Look for unusual login times, multiple failures |
| 5 | Alert creation | Use rsyslog action with if-statement |

## Solution

See [SOLUTION.md](SOLUTION.md)

---

## Additional Practice

- Set up TLS encryption for syslog
- Configure log rotation
- Create Kibana dashboards

---

**Back to:** [Main README](../README.md)