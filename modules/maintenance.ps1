# ============================================================
#  NFS CLI - maintenance.ps1
#  System maintenance, Network tools, and Health reports
# ============================================================
. "$PSScriptRoot\helpers.ps1"

function Show-MaintenanceMenu {
    while ($true) {
        Clear-Host
        Write-Section "MAINTENANCE & NETWORK"
        Write-Host ""
        Write-Host "  +-----------------------------------------------------+" -ForegroundColor DarkCyan
        Write-Host "  |  SYSTEM HEALTH                                      |" -ForegroundColor Cyan
        Write-Host "  |  1.  Generate Battery Health Report (HTML)          |" -ForegroundColor White
        Write-Host "  |  2.  Run System File Checker (SFC /ScanNow)         |" -ForegroundColor White
        Write-Host "  |  3.  Run Disk Cleanup (Quick Sage)                  |" -ForegroundColor White
        Write-Host "  |                                                     |" -ForegroundColor DarkCyan
        Write-Host "  |  NETWORK TOOLS                                      |" -ForegroundColor Cyan
        Write-Host "  |  4.  Flush DNS & Reset IP Stack                     |" -ForegroundColor White
        Write-Host "  |  5.  Ping Google (Stability Test)                   |" -ForegroundColor White
        Write-Host "  |                                                     |" -ForegroundColor DarkCyan
        Write-Host "  |  APP MANAGEMENT                                     |" -ForegroundColor Cyan
        Write-Host "  |  U.  UPDATE ALL INSTALLED APPS (Winget)             |" -ForegroundColor Green
        Write-Host "  |                                                     |" -ForegroundColor DarkCyan
        Write-Host "  |  B.  Back                                           |" -ForegroundColor DarkGray
        Write-Host "  +-----------------------------------------------------+" -ForegroundColor DarkCyan
        Write-Host ""
        $choice = (Read-Host "  Select").Trim().ToUpper()

        switch ($choice) {
            "1"  { Invoke-BatteryReport }
            "2"  { Invoke-SFCScan }
            "3"  { Invoke-DiskCleanup }
            "4"  { Invoke-NetworkReset }
            "5"  { Invoke-PingTest }
            "U"  { Invoke-UpdateAll }
            "B"  { return }
            default { Write-Warn "Invalid option." ; Start-Sleep 1 }
        }
    }
}

function Invoke-BatteryReport {
    Write-Section "BATTERY REPORT"
    $path = "$env:USERPROFILE\Desktop\BatteryReport.html"
    Write-Step "Generating report to Desktop..."
    powercfg /batteryreport /output $path | Out-Null
    Write-Success "Report saved to Desktop: BatteryReport.html"
    $open = Read-Host "  Open it now? (Y/N)"
    if ($open.ToUpper() -eq "Y") { Start-Process $path }
    Pause-Menu
}

function Invoke-SFCScan {
    Write-Section "SYSTEM FILE CHECKER"
    if (-not (Assert-Admin)) { return }
    Write-Step "Starting SFC Scan (This may take a while)..."
    sfc /scannow
    Write-Success "Scan process complete."
    Pause-Menu
}

function Invoke-DiskCleanup {
    Write-Section "DISK CLEANUP"
    if (-not (Assert-Admin)) { return }
    Write-Step "Running safe cleanup (Sagemode 1)..."
    cleanmgr /sagerun:1
    Write-Success "Cleanup process launched."
    Pause-Menu
}

function Invoke-NetworkReset {
    Write-Section "NETWORK RESET"
    if (-not (Assert-Admin)) { return }
    Write-Step "Flushing DNS..."
    ipconfig /flushdns | Out-Null
    Write-Step "Resetting Winsock..."
    netsh winsock reset | Out-Null
    Write-Step "Resetting IP Stack..."
    netsh int ip reset | Out-Null
    Write-Success "Network settings reset successfully."
    Pause-Menu
}

function Invoke-PingTest {
    Write-Section "PING TEST"
    Write-Info "Pinging google.com (5 packets)..."
    ping google.com -n 5
    Pause-Menu
}

function Invoke-UpdateAll {
    Write-Section "UPDATE ALL APPS"
    Write-Step "Scanning for available updates..."
    
    # Get the raw output
    $raw = winget upgrade --include-unknown
    
    # Find the header line to determine column positions
    $headerLine = $raw | Select-String -Pattern "Name\s+Id\s+Version"
    if (-not $headerLine) {
        Write-Err "Could not parse update table."
        Pause-Menu ; return
    }
    
    $headerText = $headerLine.ToString()
    $idStart = $headerText.IndexOf("Id")
    $versionStart = $headerText.IndexOf("Version")
    $idLength = $versionStart - $idStart

    $ids = @()
    # Skip headers and separator lines
    foreach ($line in ($raw | Select-Object -Skip 2)) {
        if ($line.Length -gt $versionStart) {
            $id = $line.Substring($idStart, $idLength).Trim()
            # Basic validation: IDs shouldn't be empty or contain only dashes
            if (-not [string]::IsNullOrWhiteSpace($id) -and $id -ne "Id" -and $id -notmatch "^-+$") {
                $ids += $id
            }
        }
    }

    if ($ids.Count -eq 0) {
        Write-Success "No updates found. All apps are up to date!"
    } else {
        Write-Info "Found $($ids.Count) updates. Starting sequence..."
        foreach ($id in $ids) {
            Install-WingetApp "Updating $id" $id
        }
        Write-Success "All updates completed."
    }
    Pause-Menu
}
