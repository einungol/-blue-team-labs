# Career Path Guide: From Beginner to SOC Analyst

> A complete roadmap for transitioning into a cybersecurity blue team career

---

## 📊 Overview

This guide provides a step-by-step path from having no experience to becoming a employed SOC Analyst. It maps directly to the labs in this repository.

### Target Timeline: 6-12 months

| Phase | Duration | Goal |
|-------|----------|------|
| Phase 1 | Months 1-3 | Build foundations |
| Phase 2 | Months 4-6 | Gain practical skills |
| Phase 3 | Months 7-9 | Get certified |
| Phase 4 | Months 10-12 | Land first job |

---

## 🎯 Target Roles

### Primary Target: SOC Analyst Tier 1

| Aspect | Details |
|--------|---------|
| **Salary (Thailand)** | 25,000 - 45,000 THB/month |
| **Salary (Remote/US)** | $50,000 - $70,000/year |
| **Skills Required** | Basic security concepts, log analysis, SIEM basics |
| **Certification** | CompTIA Security+ (preferred) |

### Secondary Targets

| Role | Priority | Difficulty |
|------|----------|------------|
| Security Analyst | 2nd | Similar to SOC |
| Junior Incident Response | 3rd | More advanced |
| Security Operations | 4th | Requires experience |
| Threat Hunter | 5th | Requires strong skills |

---

## 📚 Learning Path (Mapped to Labs)

### Phase 1: Foundations (Months 1-3)

#### Month 1: Networking Fundamentals

**Daily Study:** 1-2 hours
**Lab Focus:** [Lab 04 - Network Analysis](../04-network-analysis/README.md)

| Week | Topics | Labs |
|------|--------|------|
| 1 | TCP/IP, UDP, DNS | [Lab 04](../04-network-analysis/README.md) |
| 2 | HTTP/HTTPS, Ports | [Lab 08](../08-network-forensics/README.md) |
| 3 | Firewalls, VPNs | Review Lab 04 |
| 4 | **Assessment** | Create network diagram |

**Resources:**
- Professor Messer Network+ (YouTube - Free)
- [TryHackMe Networking](https://tryhackme.com)

#### Month 2: Operating Systems Security

**Daily Study:** 1-2 hours
**Lab Focus:** [Lab 01 - Brute Force Analysis](../01-bruteforce/README.md)

| Week | Topics | Labs |
|------|--------|------|
| 1 | Windows Security Model | [Lab 01](../01-bruteforce/README.md) |
| 2 | Linux Security Basics | [Lab 05](../05-privilege-escalation/README.md) |
| 3 | Event Logs | [Lab 01](../01-bruteforce/README.md) |
| 4 | PowerShell Basics | [Lab 01 scripts](../01-bruteforce/scripts/analyze.ps1) |

**Resources:**
- [Windows Security Documentation](https://learn.microsoft.com/en-us/windows/security/)
- Linux Command Line Basics

#### Month 3: Security Concepts

**Daily Study:** 1-2 hours

| Week | Topics | Labs |
|------|--------|------|
| 1 | CIA Triad, AAA | [Lab 10](../10-incident-response/README.md) |
| 2 | Attack Types | [Lab 02](../02-malware-analysis/README.md) |
| 3 | Malware Types | [Lab 02](../02-malware-analysis/README.md), [Lab 09](../09-malware-analysis/README.md) |
| 4 | **Security+ Prep** | Study guide |

---

### Phase 2: Hands-On Skills (Months 4-6)

#### Month 4: SIEM & Log Analysis

**Daily Study:** 2 hours
**Lab Focus:** [Lab 07 - SIEM Analysis](../07-siem-analysis/README.md)

| Week | Topics | Labs |
|------|--------|------|
| 1 | Splunk Basics | [Lab 07](../07-siem-analysis/README.md) |
| 2 | SPL Queries | [Lab 07](../07-siem-analysis/README.md) |
| 3 | Log Correlation | [Lab 01 + Lab 07](../07-siem-analysis/README.md) |
| 4 | Dashboard Creation | Build your own |

**Goal:** Be able to write basic SPL queries

#### Month 5: Incident Response & Forensics

**Daily Study:** 2 hours

| Week | Topics | Labs |
|------|--------|------|
| 1 | IR Framework | [Lab 10](../10-incident-response/README.md) |
| 2 | Phishing Investigation | [Lab 06](../06-phishing-investigation/README.md) |
| 3 | Memory Forensics | [Lab 03](../03-memory-forensics/README.md) |
| 4 | Network Forensics | [Lab 08](../08-network-forensics/README.md) |

**Goal:** Complete full incident response for a case

#### Month 6: Threat Hunting & Detection

**Daily Study:** 2 hours

| Week | Topics | Labs |
|------|--------|------|
| 1 | MITRE ATT&CK | [Lab 11](../11-threat-hunting/README.md) |
| 2 | Sigma Rules | [Lab 14](../14-detection-engineering/README.md) |
| 3 | YARA Rules | [Lab 13](../13-yara-rules/README.md) |
| 4 | Cloud Security | [Lab 12](../12-cloud-security/README.md) |

**Goal:** Create 3 detection rules for your portfolio

---

### Phase 3: Certification (Months 7-9)

#### Recommended Certification Path

| Cert | Month | Priority | Salary Impact |
|------|-------|----------|---------------|
| CompTIA Security+ | 7-8 | 🔴 Must Have | +15-20% |
| CompTIA CySA+ | 9-12 | 🟡 Nice to Have | +10-15% |

#### Security+ Study Plan

**Resources:**
- [Professor Messer Security+](https://www.professormesser.com/security-plus/sy0-601/) (Free YouTube)
- [Dion Training](https://www.diontraining.com/) (Paid course)
- Official Study Guide Book

**Exam Details:**
- Questions: 90
- Time: 90 minutes
- Passing Score: 750/900
- Cost: ~$370 (discounted: ~$250)

---

### Phase 4: Job Search (Months 10-12)

#### Building Your Portfolio

| Component | Description | Priority |
|----------|-------------|----------|
| **GitHub Repository** | This blue-team-labs repo | 🔴 Required |
| **LinkedIn Profile** | Professional presence | 🔴 Required |
| **Blog Posts** | 2-3 technical writeups | 🟡 Important |
| **CTF Profile** | TryHackMe/HackTheBox | 🟡 Important |

#### Resume Preparation

**Structure:**
```
1. Professional Summary (3-4 lines)
2. Technical Skills (categorized)
3. Labs & Projects (with links)
4. Certifications (in progress + completed)
5. Education
```

**Keywords to Include:**
- SOC Analysis
- SIEM (Splunk, ELK)
- Log Analysis
- Incident Response
- Threat Hunting
- Detection Engineering

#### Where to Find Jobs

| Platform | Type | Notes |
|----------|------|-------|
| LinkedIn | All | Most jobs posted here |
| Indeed | All | Filter "entry level" |
| CyberSecJobs | Niche | Security-specific |
| Upwork | Contract | Good for experience |
| Remote OK | Remote | Work from anywhere |

---

## 📋 Milestones

### Monthly Checklist

| Month | Milestone | Verification |
|-------|-----------|--------------|
| 1 | Complete Labs 1-4 | GitHub commit history |
| 2 | Complete Labs 5-8 | GitHub commit history |
| 3 | Pass Security+ Part 1 | Practice exam >80% |
| 4 | Complete Labs 9-12 | GitHub commit history |
| 5 | Complete Labs 13-15 | GitHub commit history |
| 6 | Write 2 Blog Posts | Blog published |
| 7 | Take Security+ Exam | Certificate |
| 8 | Update LinkedIn | Profile complete |
| 9 | Apply to 20+ Jobs | Application log |
| 10 | Interview Practice | Mock interviews |
| 11 | Receive Offer | Job accepted |
| 12 | Start New Job | First day! |

---

## 💡 Interview Preparation

### Common SOC Analyst Interview Questions

#### Technical Questions

**Q: What is the difference between symmetric and asymmetric encryption?**
> A: Symmetric uses the same key for encryption/decryption (fast), asymmetric uses key pairs - public/private (slower but more secure for key exchange).

**Q: How would you investigate a suspicious PowerShell process?**
> A: 1) Check parent process, 2) Analyze command line arguments, 3) Check network connections, 4) Look for encoded commands, 5) Check file on disk.

**Q: What is the Cyber Kill Chain?**
> A: Reconnaissance → Weaponization → Delivery → Exploitation → Installation → Command & Control → Actions on Objectives

**Q: How does SIEM correlation work?**
> A: SIEM collects logs from multiple sources, normalizes them, and applies rules to identify patterns across different log types.

**Q: What is the difference between HIDS and NIDS?**
> A: HIDS (Host-based IDS) monitors individual systems, NIDS (Network-based IDS) monitors network traffic.

#### Behavioral Questions

**Q: Tell me about a time you worked under pressure.**
> A: [Use STAR method - Situation, Task, Action, Result]

**Q: Why do you want to work in security?**
> A: [Be genuine - show passion for learning and protecting]

**Q: How do you stay current with security news?**
> A: Follow security researchers on Twitter, read SANS news, subscribe to threat intelligence feeds.

---

## 🔧 Practical Skills Checklist

Before applying, ensure you can:

| Skill | How to Verify |
|-------|--------------|
| Read Windows Event Logs | Analyze Lab 01 logs |
| Write basic Splunk query | Complete Lab 07 |
| Analyze network traffic | Complete Lab 08 |
| Investigate phishing email | Complete Lab 06 |
| Create detection rule | Complete Lab 14 |
| Write incident report | Complete Lab 10 |

---

## 🌐 Remote Work Options

### Companies Hiring Remote SOC Analysts

| Company | Location | Notes |
|----------|----------|-------|
| CrowdStrike | Remote (US) | Premium pay |
| SentinelOne | Remote (US) | Good benefits |
| Arctic Wolf | Remote (US) | 24/7 SOC |
| Orange Cyberdefense | Remote (EU) | International |
| SecureWorks | Remote | Global |

### Part-Time Options

- **Weekend SOC Coverage:** Many companies need weekend coverage
- **Contract Work:** Start with 6-month contracts on Upwork
- **MSSP:** Managed Service Providers often hire part-time

---

## 📈 Salary Expectations

### Thailand (Bangkok)

| Level | Salary (THB/month) |
|-------|---------------------|
| SOC Analyst Entry | 25,000 - 35,000 |
| SOC Analyst (1-3 years) | 35,000 - 60,000 |
| SOC Analyst (3-5 years) | 60,000 - 100,000 |
| Security Engineer | 80,000 - 150,000 |

### US (Remote)

| Level | Salary (USD/year) |
|-------|-------------------|
| SOC Tier 1 | $50,000 - $70,000 |
| SOC Tier 2 | $70,000 - $95,000 |
| SOC Tier 3 / Senior | $95,000 - $140,000 |

---

## 🔗 Related Resources

### This Repository

- [Lab 01-14](../README.md) - All hands-on labs
- [Home Lab Setup](15-home-lab-setup/README.md) - Build your lab
- [Learning Resources](../README.md#resources)

### External Resources

- [TryHackMe SOC Path](https://tryhackme.com)
- [Let'sDefend](https://letsdefend.io)
- [CyberDefenders](https://cyberdefenders.org)
- [John Hammond YouTube](https://youtube.com/johnhammond010)

---

## ❓ FAQ

**Q: Do I need a degree?**
> A: No. Many SOC analysts are hired with certifications and hands-on experience. Security+ can substitute for 2 years of experience.

**Q: How many jobs should I apply to?**
> A: Aim for 10-20 quality applications per week. Customize each resume.

**Q: What if I have no IT background?**
> A: Start with networking basics, complete CompTIA Network+ first, then Security+.

**Q: How long does it take to get hired?**
> A: Typically 3-6 months after completing the learning path. Could be faster with strong portfolio.

---

## 📝 Next Steps

1. **This Week:** Complete Lab 01-04
2. **This Month:** Complete Lab 01-14
3. **Next Month:** Set up home lab
4. **Month 3:** Take Security+ practice exam
5. **Month 6:** Schedule Security+ exam

---

**Guide Version:** 1.0
**Last Updated:** 2024-03-20

**Back to:** [Main README](README.md)