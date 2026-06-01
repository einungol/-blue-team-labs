# Lab 18: Phishing Document Analysis

**Difficulty:** Intermediate ⭐⭐  
**Tools:** olevba, pcodedmp,officeparser, pdfid  
**Time:** 45 minutes

## Scenario

A user received a suspicious document attachment. Analyze the file to determine if it's malicious and extract IOCs.

### Questions:
1. Does the document contain macros or malicious code?
2. What actions does the macro perform?
3. What are the IOCs (URLs, IPs, file paths)?
4. How does it achieve persistence?
5. What is the risk level?

## Prerequisites

### Knowledge Required
- Understanding of Office document formats
- Basic macro/script analysis
- Static malware analysis concepts

### Tools Needed
- [oledump](https://blog.didierstevens.com/oledump-py/) - Office document analysis
- [olevba](https://github.com/decalage2/oletools/wiki/olevba) - VBA macro extraction
- [pcodedmp](https://github.com/b浆hne/pcodedmp) - P-code disassembly
- [pdfid](https://github.com/kevthehermit/pdfid) - PDF analysis

### Pre-Reading (Optional)
- [Malicious Macro Analysis](https://www.sans.org/reading-room/whitepapers/malware/malicious-document-analysis-110)
- [oletools Documentation](https://github.com/decalage2/oletools)

---

## Step-by-Step Walkthrough

### Step 1: Basic File Analysis

```bash
# Check file type
file suspicious.docm

# Get hash
sha256sum suspicious.docm
```

### Step 2: Extract Macros with olevba

```bash
# Extract and analyze VBA macros
olevba suspicious.docm

# Output to file
olevba suspicious.docm > macro_analysis.txt
```

### Step 3: Extract OLE Streams

```bash
# List OLE streams
oledump.py suspicious.docm

# Extract specific stream
oledump.py -s 7 -d suspicious.docm > output.bin
```

### Step 4: Analyze PDF (if PDF file)

```bash
# Check PDF for suspicious elements
pdfid.py suspicious.pdf

# Extract objects
pdf-parser.py suspicious.pdf
```

### Step 5: Decode Obfuscated Strings

```bash
# Look for encoded strings
strings suspicious.docm | grep -E "http|cmd|powershell|wscript"

# Decode base64
echo "encoded_string" | base64 -d
```

## Challenge Questions

| # | Question | Hint |
|---|----------|------|
| 1 | Macros? | Use olevba to extract VBA code |
| 2 | Actions | Look for Shell, Exec, CreateObject calls |
| 3 | IOCs | Search for URLs, IPs in macro code |
| 4 | Persistence | Check for AutoOpen, Document_Open |
| 5 | Risk level | Based on macro capabilities |

## Solution

See [SOLUTION.md](SOLUTION.md)

---

## Common Malicious Macros

```vba
' Example malicious macro
Sub Document_Open()
    Dim cmd As String
    cmd = "powershell -enc JABjAGwA..."
    Shell cmd, vbHide
End Sub

' Another technique
Sub AutoOpen()
    Set obj = CreateObject("WScript.Shell")
    obj.Run "malicious.exe", 0
End Sub
```

---

## Indicators of Malicious Document

| Indicator | Description |
|-----------|-------------|
| Macros present | Document contains VBA code |
| AutoOpen/AutoClose | Executes on open/close |
| Shell/Exec calls | Executes commands |
| Obfuscated strings | Encoded payloads |
| External URLs | Downloads additional payloads |
| Suspicious file paths | Temp, AppData folders |

---

## Remediation Steps

1. **Quarantine** - Isolate the document
2. **Block** - Add sender to blocklist
3. **Scan** - Full endpoint scan
4. **Notify** - Inform users of phishing campaign
5. **Train** - Security awareness training

---

**Back to:** [Main README](../README.md)