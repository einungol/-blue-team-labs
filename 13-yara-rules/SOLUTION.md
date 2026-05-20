# Lab 13: Solution

## Answers

| # | Answer |
|---|--------|
| 1 | **Domain: api.malware-c2.xyz, Registry: HKCU\Software\Update, Process: update.exe** |
| 2 | **YARA rule with meta, strings, condition** |
| 3 | **Use specific strings, add false positive filters** |
| 4 | **Test on malware + clean files** |
| 5 | **Deploy to EDR, SIEM, or endpoint** |

## Strings Analysis

### Extracted Strings (sample)

```
C:\Users\user\AppData\Local\Temp\update.exe
api.malware-c2.xyz
WindowsUpdate
User-Agent: Mozilla/5.0
Software\Microsoft\Windows\CurrentVersion\Run
```

### Classification

| String | Type | Use in Rule? |
|--------|------|--------------|
| api.malware-c2.xyz | C2 Domain | ✅ Yes |
| WindowsUpdate | Registry | ✅ Yes |
| update.exe | Filename | ⚠️ Maybe (common) |
| C:\Temp\ | Path | ❌ Too common |

## Final YARA Rule

```yara
rule Malware_Trojan_Generic
{
    meta:
        author = "Blue Team Labs"
        description = "Detects generic trojan with C2 capability"
        date = "2024-03-20"
        hash = "a1b2c3d4e5f6"
    strings:
        $domain = "api.malware-c2.xyz" fullword
        $reg_key = "Software\\Microsoft\\Windows\\CurrentVersion\\Run" fullword
        $process = "update.exe" fullword
    condition:
        $domain and ($reg_key or $process)
}
```

## Testing

### Test on Malware Sample
```bash
$ yara -m rule.yar sample.exe
sample.exe: Malware_Trojan_Generic
```

### Test on Clean File
```bash
$ yara -m rule.yar notepad.exe
# No matches - good!
```

### Test on Similar (false positive check)
```bash
$ yara -m rule.yar legitimate_update.exe
# Should NOT match
```

## Deployment Options

| Platform | How to Deploy |
|----------|--------------|
| Splunk | Add to Sysmon config |
| CrowdStrike | Custom YARA rules |
| Windows Defender | Advanced scanning |
| ClamAV | Integrate YARA |

## Best Practices

1. **Unique strings only** - Avoid common Windows paths
2. **Test thoroughly** - Scan malware + clean files
3. **Version in Git** - Track rule changes
4. **Document** - Include metadata with hash
5. **Update regularly** - Malware changes often