# Lab 13: YARA Rules Development

**Difficulty:** Beginner ⭐  
**Tools:** YARA, VirusTotal, String analysis  
**Time:** 35 minutes

## Scenario

You found a suspicious file. Create a YARA rule to detect it and similar threats.

### Questions:
1. What strings are unique to this malware?
2. How do you write the YARA rule?
3. What are the false positive considerations?
4. How do you test the rule?
5. Where would you deploy it?

## Step-by-Step Walkthrough

### Step 1: Analyze Strings

```bash
# Extract strings from file
strings suspicious.exe | head -100

# Look for unique strings
strings suspicious.exe | grep -E "[a-zA-Z0-9]{20,}"
```

### Step 2: Identify Unique Indicators

| Type | Example | Reliability |
|------|---------|-------------|
| File path | C:\Temp\malware.exe | Medium |
| Registry | HKCU\Software\Update | High |
| Domain | malware-c2.xyz | High |
| PDB | C:\project\evil.pdb | Very High |

### Step 3: Write YARA Rule

```yara
rule Suspicious_Malware_Generic
{
    meta:
        author = "Your Name"
        description = "Detects suspicious malware"
        date = "2024-03-20"
    strings:
        $s1 = "malware-c2.xyz" fullword
        $s2 = "WindowsUpdate" fullword
        $s3 = "svchost.exe" fullword
    condition:
        2 of them
}
```

### Step 4: Test Rule

```bash
# Test against sample
yara -r rule.yar suspicious.exe

# Scan directory
yara -r rule.yar /malware/samples/
```

## Challenge Questions

| # | Question | Expected Answer |
|---|----------|-----------------|
| 1 | Unique strings | Domain, Registry key, specific process name |
| 2 | YARA structure | meta, strings, condition sections |
| 3 | False positives | Use specific strings, avoid common words |
| 4 | Testing | Test on known malware + clean files |
| 5 | Deployment | EDR, SIEM, endpoint protection |

## Solution

See [SOLUTION.md](SOLUTION.md)