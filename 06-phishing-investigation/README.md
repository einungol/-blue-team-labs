# Lab 06: Phishing Email Investigation

**Difficulty:** Beginner ⭐  
**Tools:** Email headers, URL scan, VirusTotal  
**Time:** 30 minutes

## Prerequisites

### Knowledge Required
- Understanding of email protocols (SMTP, POP3, IMAP)
- Familiarity with email header format
- Basic knowledge of phishing attack techniques

### Tools Needed
- [VirusTotal](https://www.virustotal.com) - Domain/file reputation check
- [URLScan.io](https://urlscan.io) - URL analysis
- [Email Header Analyzer](https://mailanalysis.org) - Header parsing tool
- Text editor

### Pre-Reading (Optional)
- [How to Analyze Email Headers](https://www.proofpoint.com/us/blog-email-security/how-analyze-email-headers)
- [Phishing Email Indicators](https://www.csoonline.com/article/411593/phishing-email-detection-cheat-sheet.html)

## Scenario

A user reported a suspicious email. Analyze to determine:
1. Is this a phishing email?
2. Where did it originate?
3. What is the malicious URL?
4. What action should user take?
5. Are there other recipients?

## Files Provided

- `email.eml` - Raw email file

## Step-by-Step Walkthrough

### Step 1: Examine Headers

```bash
# View headers
cat email.eml | grep -E "^From:|^To:|^Subject:|Received:|Return-Path:"
```

### Step 2: Analyze URLs

```bash
# Extract URLs
grep -oE "http[s]?://[^<]+" email.eml
```

### Step 3: Check Domain Reputation

```bash
# Use VirusTotal API (manual check)
# https://www.virustotal.com/gui/domain/{domain}
```

### Step 4: Verify Sender

```bash
# Check DKIM/SPF/DMARC
grep -E "DKIM-Signature|Authentication-Results"
```

## Challenge Questions

| # | Question | Hint |
|---|----------|------|
| 1 | Is phishing? | Check for urgency, links, attachments |
| 2 | Origin | Check Received headers, IP |
| 3 | Malicious URL | Extract and scan link |
| 4 | Action | Quarantine, warn users, block sender |
| 5 | Other recipients | Check BCC or multiple To: |

## Solution

See [SOLUTION.md](SOLUTION.md)