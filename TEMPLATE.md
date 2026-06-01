# 📝 Lab Template - Standard Structure

> Use this template to create new labs consistently

---

## Folder Structure

```
[Lab-Name]/
├── README.md           # Main lab guide
├── SOLUTION.md         # Answers and walkthrough
├── CHALLENGE.md        # Extended challenge (optional)
├── logs/               # Sample data
│   └── *.json, *.pcap, etc.
├── scripts/            # Analysis scripts
│   └── *.sh, *.ps1, *.py
└── assets/             # Images/diagrams (if needed)
```

---

## README.md Template

```markdown
# Lab XX: [Topic Name]

**Difficulty:** [Beginner ⭐ / Intermediate ⭐⭐ / Advanced ⭐⭐⭐]
**Tools:** [Tool1, Tool2, Tool3]
**Time:** [XX minutes]

## Scenario

[Describe the scenario - what happened, what the analyst needs to find]

### Questions:
1. [Question 1]
2. [Question 2]
3. [Question 3]
4. [Question 4]
5. [Question 5]

## Prerequisites

### Knowledge Required
- [Knowledge requirement 1]
- [Knowledge requirement 2]

### Tools Needed
- [Tool 1](link) - Description
- [Tool 2](link) - Description

### Pre-Reading (Optional)
- [Article/Resource 1](link)
- [Article/Resource 2](link)

## Step-by-Step Walkthrough

### Step 1: [Step Name]

[Description of what to do]

```bash
# Example command
command --option argument
```

### Step 2: [Step Name]

[Description]

### Step 3: [Step Name]

[Description]

## Challenge Questions

| # | Question | Hint |
|---|----------|------|
| 1 | [Q1] | [Hint 1] |
| 2 | [Q2] | [Hint 2] |
| 3 | [Q3] | [Hint 3] |
| 4 | [Q4] | [Hint 4] |
| 5 | [Q5] | [Hint 5] |

## Solution

See [SOLUTION.md](SOLUTION.md)

## Additional Practice

- [Practice idea 1]
- [Practice idea 2]

## References

- [Reference 1](link)
- [Reference 2](link)

---

**Back to:** [Main README](../README.md)
```

---

## SOLUTION.md Template

```markdown
# Lab XX: [Topic Name] - Solution

## Answers to Challenge Questions

### Question 1: [Question]
**Answer:** [Answer]

**Evidence:**
```bash
# Command to verify
command --option argument
```

**Explanation:**
[Detailed explanation of the answer]

---

### Question 2: [Question]
**Answer:** [Answer]

**Evidence:**
[Show command output or screenshot]

---

### Question 3: [Question]
**Answer:** [Answer]

---

### Question 4: [Question]
**Answer:** [Answer]

---

### Question 5: [Question]
**Answer:** [Answer]

---

## Step-by-Step Solution

### Step 1: [Step Name]

[Detailed walkthrough]

```bash
# Command with expected output
$ command --option
expected_output
```

### Step 2: [Step Name]

[Detailed walkthrough]

### Step 3: [Step Name]

[Detailed walkthrough]

---

## IOC Summary

| Type | Value |
|------|-------|
| IP | [value] |
| Domain | [value] |
| File Hash | [value] |
| Registry | [value] |

---

## Detection Rules

### Sigma Rule (Optional)

```yaml
title: [Title]
id: [uuid]
status: [experimental/stable]
logsource:
  category: [category]
  product: [product]
detection:
  selection:
    [field]: [value]
  condition: selection
level: [low/medium/high/critical]
```

### YARA Rule (Optional)

```yara
rule [Name]
{
    meta:
        author = "Blue Team Labs"
        description = "[Description]"
    strings:
        $s1 = "[string]" [modifiers]
    condition:
        [condition]
}
```

---

## Remediation Steps

### Immediate (0-1 hour)
- [ ] Action 1
- [ ] Action 2

### Short-term (1-24 hours)
- [ ] Action 3
- [ ] Action 4

### Long-term (1-4 weeks)
- [ ] Action 5
- [ ] Action 6

---

## References

- [MITRE ATT&CK Technique](link)
- [Tool Documentation](link)
- [Related Lab](link)

---

**Back to:** [README.md](README.md)
```

---

## File Naming Convention

| File Type | Naming | Example |
|-----------|--------|---------|
| README | `README.md` | `01-bruteforce/README.md` |
| Solution | `SOLUTION.md` | `01-bruteforce/SOLUTION.md` |
| Challenge | `CHALLENGE.md` | - |
| Logs | Descriptive | `splunk_logs.json` |
| Scripts | Descriptive + ext | `analyze.ps1` |
| Assets | Descriptive | `network-diagram.png` |

---

## Difficulty Rating

| Level | Symbol | Description |
|-------|--------|-------------|
| Beginner | ⭐ | No prior experience needed |
| Intermediate | ⭐⭐ | Basic security knowledge required |
| Advanced | ⭐⭐⭐ | Professional experience needed |

---

## Checklist for New Lab

Before publishing a new lab, verify:

- [ ] README.md complete with all sections
- [ ] Prerequisites section included
- [ ] Tools listed with links
- [ ] Step-by-step instructions clear
- [ ] Challenge questions have hints
- [ ] SOLUTION.md with all answers
- [ ] Sample logs/data provided (in logs/)
- [ ] Scripts work correctly (in scripts/)
- [ ] Links to related labs
- [ ] References accurate

---

## Example: Complete Lab Structure

```
05-privilege-escalation/
├── README.md              ✅ Main guide
├── SOLUTION.md            ✅ Answers
├── logs/
│   ├── bash_history      ✅ Sample data
│   ├── auth.log
│   └── syslog
└── scripts/
    └── analyze.sh        ✅ Helper script
```

---

## Integration with Other Labs

Reference related labs using relative paths:

```markdown
- Related: [Lab 01 - Brute Force Analysis](../01-bruteforce/README.md)
- Next: [Lab 07 - SIEM Analysis](../07-siem-analysis/README.md)
- Prerequisite: [Lab 15 - Home Lab Setup](../15-home-lab-setup/README.md)
```

---

**Template Version:** 1.0
**Last Updated:** 2024-03-20

**Back to:** [Main README](README.md)