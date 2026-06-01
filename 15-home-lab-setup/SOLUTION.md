# Lab 15: Home Lab Setup - Solution

This is a setup lab - there's no single solution. This guide helps you verify your setup is working correctly.

## Verification Checklist

### Step 1: VirtualBox Installation
- [ ] VirtualBox installed successfully
- [ ] VT-x/AMD-V enabled in BIOS
- [ ] Host-only network adapter created (vboxnet0)

### Step 2: Virtual Machines Created

| VM | RAM | Disk | Status |
|----|-----|------|--------|
| Kali-Linux | 2 GB | 50 GB | [ ] |
| Windows-10 | 4 GB | 80 GB | [ ] |
| Splunk-SIEM | 4 GB | 100 GB | [ ] |

### Step 3: Network Connectivity

Test ping between VMs:

```bash
# From Kali Linux
ping 192.168.100.20  # Windows-10
ping 192.168.100.30  # Splunk-SIEM

# From Windows-10
ping 192.168.100.10  # Kali-Linux
ping 192.168.100.30  # Splunk-SIEM
```

### Step 4: Log Forwarding

Verify Splunk is receiving logs:

1. Open Splunk Web UI: http://192.168.100.30:8000
2. Go to Search > Search
3. Run: `index=* | head 100`
4. You should see Windows security events

### Step 5: Tools Verification

```bash
# In Kali Linux
which nmap
which metasploit
which wireshark

# In Windows
# Check Sysmon is running
Get-Process | Where-Object {$_.Name -eq "sysmon"}
```

---

## Common Issues and Fixes

### Issue 1: VMs Can't Connect to Each Other
**Solution:** Check Host-only network adapter
```bash
# Verify vboxnet0 exists
VBoxManage list hostonlyifs
```

### Issue 2: Splunk Not Receiving Logs
**Solution:** Check forwarder connection
```powershell
# On Windows, restart Splunk Forwarder
cd C:\Program Files\SplunkUniversalForwarder\bin
.\splunk restart
```

### Issue 3: Slow VM Performance
**Solution:**
- Increase RAM allocation
- Enable VT-x in BIOS
- Use SSD for disk

---

## Next Steps

After completing setup:
1. Continue to [Lab 01 - Brute Force Analysis](../01-bruteforce/README.md)
2. Practice SIEM queries in [Lab 07 - SIEM Analysis](../07-siem-analysis/README.md)
3. Move to [Lab 11 - Threat Hunting](../11-threat-hunting/README.md)

---

**Back to:** [README.md](README.md)