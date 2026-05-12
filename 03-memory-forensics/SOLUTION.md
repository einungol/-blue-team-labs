# Lab 03: Solution

## Answers

| # | Answer |
|---|--------|
| 1 | **45 processes (explorer, chrome, notepad, etc.)** |
| 2 | **svchost.exe (PID 4152) - hidden, no parent** |
| 3 | **2 connections: 192.168.1.105:443, 10.0.0.5:8080** |
| 4 | **3 hidden processes found via psscan** |
| 5 | **NTLM hashes in lsass.exe** |

## Process Analysis

### Legitimate Processes
| PID | Name | Status |
|-----|------|--------|
| 4 | System | Normal |
| 512 | smss.exe | Normal |
| 620 | csrss.exe | Normal |
| 688 | wininit.exe | Normal |
| 4152 | svchost.exe | **SUSPICIOUS** |

### Hidden Processes (psscan)
| PID | Name | Start Time |
|-----|------|------------|
| 4152 | svchost.exe | 2024-03-15 14:00:01 |
| 5234 | malware.exe | 2024-03-15 14:15:22 |
| 6123 | keylog.dll | N/A |

## Network Connections

```
Proto  Local Address          Remote Address         State      PID
TCP    192.168.1.101:443     185.243.115.84:443     ESTABLISHED  4152
TCP    192.168.1.101:8080    10.0.0.5:8080          TIME_WAIT   1234
```

## Credentials Found

```bash
# Dumped from lsass
Username: admin
NTLM: a1b2c3d4e5f6g7h8i9j0...
```

## Volatility Commands Used

```bash
vol -f memory.raw windows.pslist
vol -f memory.raw windows.psscan
vol -f memory.raw windows.netscan
vol -f memory.raw windows.lsass
vol -f memory.raw windows.registry
```

## Detection & Response

1. **Isolate** - Disconnect from network
2. **Capture** - Collect evidence before changes
3. **Analyze** - Determine scope
4. **Remediate** - Wipe and rebuild
5. **Monitor** - Watch for reinfection