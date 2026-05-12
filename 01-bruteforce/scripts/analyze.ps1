# Blue Team Lab 01 - Brute Force Analysis Script
# Usage: .\analyze.ps1 -LogFile security_events.json

param(
    [string]$LogFile = "logs\security_events.json"
)

Write-Host "=== Blue Team Lab 01: Brute Force Analysis ===" -ForegroundColor Cyan
Write-Host ""

# Load JSON logs
$logs = Get-Content $LogFile | ConvertFrom-Json

# 1. Count failed logins (Event 4625)
$failedLogins = $logs | Where-Object { $_.EventID -eq 4625 }
$uniqueIPs = $failedLogins | Select-Object -ExpandProperty IpAddress -Unique

Write-Host "[1] Attacker Source IP(s):" -ForegroundColor Yellow
$uniqueIPs | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }

# 2. Targeted usernames
$targetedUsers = $failedLogins | Select-Object -ExpandProperty TargetUserName -Unique
Write-Host "[2] Targeted Usernames:" -ForegroundColor Yellow
$targetedUsers | ForEach-Object { Write-Host "  - $_" }

# 3. Failed attempt count
$failedCount = ($failedLogins | Measure-Object).Count
Write-Host "[3] Failed Login Attempts: $failedCount" -ForegroundColor Yellow

# 4. Find successful login (Event 4624)
$successLogins = $logs | Where-Object { $_.EventID -eq 4624 }
Write-Host "[4] Successful Login(s):" -ForegroundColor Yellow
$successLogins | ForEach-Object {
    Write-Host "  - Time: $($_.TimeCreated) | User: $($_.TargetUserName) | IP: $($_.IpAddress)"
}

# 5. Post-breach activity
$postBreach = $logs | Where-Object { $_.EventID -eq 4688 -or $_.EventID -eq 4698 }
Write-Host "[5] Post-Breach Activity:" -ForegroundColor Yellow
$postBreach | ForEach-Object {
    if ($_.ProcessName) {
        Write-Host "  - Process: $($_.ProcessName) | Cmd: $($_.CommandLine)"
    }
    if ($_.TaskName) {
        Write-Host "  - Task: $($_.TaskName) | Path: $($_.Path)"
    }
}

Write-Host ""
Write-Host "=== Analysis Complete ===" -ForegroundColor Green