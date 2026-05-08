# ============================================================
#  NFS CLI - helpers.ps1
#  Shared utility functions used across all modules
# ============================================================

function Write-Success  { param($msg) Write-Host "  [OK] $msg" -ForegroundColor Green  }
function Write-Info     { param($msg) Write-Host "  [i]  $msg" -ForegroundColor Cyan   }
function Write-Warn     { param($msg) Write-Host "  [!]  $msg" -ForegroundColor Yellow }
function Write-Err      { param($msg) Write-Host "  [X]  $msg" -ForegroundColor Red    }
function Write-Step     { param($msg) Write-Host "`n  >> $msg" -ForegroundColor White }

function Show-Intro {
    Clear-Host
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $text = ">> INITIALIZING NFS PROGRAMMER CLI SYSTEM..."
    $colors = @("DarkRed", "Red", "White")
    
    foreach ($char in $text.ToCharArray()) {
        Write-Host $char -NoNewline -ForegroundColor ($colors | Get-Random)
        Start-Sleep -Milliseconds (Get-Random -Minimum 10 -Maximum 50)
    }
    Start-Sleep -Milliseconds 500
    Write-Host "`n>> LOADING ASSETS AND MODULES..." -ForegroundColor DarkGray
    for ($i = 0; $i -le 100; $i += 10) {
        Write-NFSProgress "System Core" $i
        Start-Sleep -Milliseconds 100
    }
    Write-Host "`n>> SYSTEM READY. WELCOME, NIFRAS." -ForegroundColor Green
    Start-Sleep -Milliseconds 800
}

function Write-NFSProgress {
    param([string]$Task, [int]$Percent)
    $width = 40
    $filled = [Math]::Floor($Percent / 100 * $width)
    $unfilled = $width - $filled
    $bar = ("#" * $filled) + ("-" * $unfilled)
    $color = if ($Percent -lt 50) { "DarkRed" } elseif ($Percent -lt 90) { "Red" } else { "White" }
    Write-Host "`r  [$Task] [$bar] $Percent%" -NoNewline -ForegroundColor $color
    if ($Percent -ge 100) { Write-Host "" }
}

function Write-Indeterminate-Bar {
    param([string]$Label = "Working")
    $frames = @("-", "\", "|", "/")
    foreach ($f in $frames) {
        Write-Host "`r  [$f] $Label..." -NoNewline -ForegroundColor Red
        Start-Sleep -Milliseconds 100
    }
}

function Write-HR {
    param([string]$Char = "-", [int]$Width = 54)
    Write-Host ("  " + ($Char * $Width)) -ForegroundColor DarkGray
}

function Write-Section {
    param([string]$Title)
    Write-Host ""
    Write-Host "  == $Title " -ForegroundColor Red -NoNewline
    Write-Host ("=" * [Math]::Max(1, 48 - $Title.Length)) -ForegroundColor DarkRed
}

function Pause-Menu {
    Write-Host ""
    Write-Host "  Press any key to return to the menu..." -ForegroundColor DarkGray
    try {
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    } catch {
        # Fallback for non-interactive sessions or restricted terminals
        $null = Read-Host
    }
}

function Confirm-Back {
    Write-Host ""
    Write-Host "  [B] Back   [Q] Quit" -ForegroundColor DarkGray
    $k = Read-Host "  >"
    return $k.Trim().ToUpper()
}

function Assert-Winget {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Err "winget not found. Install App Installer from the Microsoft Store."
        Pause-Menu
        return $false
    }
    return $true
}

function Refresh-Explorer {
    # Notifies the shell that settings have changed (refreshes icons/extensions)
    $code = '[DllImport("shell32.dll")] public static extern void SHChangeNotify(uint wEventId, uint uFlags, IntPtr dwItem1, IntPtr dwItem2);'
    $type = Add-Type -MemberDefinition $code -Name "Shell32" -Namespace "WinAPI" -PassThru
    $type::SHChangeNotify(0x08000000, 0x0000, [IntPtr]::Zero, [IntPtr]::Zero)
}

function Install-WingetApp {
    param(
        [string]$DisplayName,
        [string]$WingetId
    )
    if ([string]::IsNullOrWhiteSpace($WingetId)) {
        Write-Err "Invalid Winget ID for $DisplayName."
        return
    }
    # Force black background using compatible ANSI for PS 5.1
    $esc = [char]27
    Write-Host "$($esc)[48;2;0;0;0m" -NoNewline 
    Write-Step "SYSTEM TASK: Processing $DisplayName ($WingetId)"
    
    try {
        # Determine if we should use 'install' or 'upgrade'
        $cmd = if ($DisplayName -like "*Updating*") { "upgrade" } else { "install" }
        
        $tempFile = New-TemporaryFile
        $process = Start-Process winget -ArgumentList "$cmd --id $WingetId -e --accept-source-agreements --accept-package-agreements --silent" -PassThru -NoNewWindow -RedirectStandardOutput $tempFile.FullName -ErrorAction Stop
        
        if ($null -eq $process) {
            Write-Err "Failed to launch winget process."
            return
        }

        $p = 0
        while (-not $process.HasExited) {
            if ($p -lt 95) { $p += 1 }
            Write-NFSProgress "Working" $p
            Start-Sleep -Milliseconds 200
        }
        
        $exitCode = $process.ExitCode
        $output = Get-Content $tempFile.FullName -Raw
        Remove-Item $tempFile.FullName -ErrorAction SilentlyContinue
        
        # Check for success indicators in output text
        $isSuccess = ($exitCode -eq 0) -or 
                     ($output -like "*Successfully installed*") -or 
                     ($output -like "*already installed*") -or 
                     ($output -like "*No available upgrade found*")
        
        # If exit code is non-zero, try the opposite command as a fallback
        if (-not $isSuccess -and $cmd -eq "install") {
             Write-Indeterminate-Bar "Switching to upgrade mode..."
             $process = Start-Process winget -ArgumentList "upgrade --id $WingetId -e --accept-source-agreements --accept-package-agreements --silent" -PassThru -NoNewWindow -Wait
             $exitCode = $process.ExitCode
             $isSuccess = ($exitCode -eq 0)
        }
        
        if ($isSuccess) {
            Write-NFSProgress "Success" 100
            Write-Success "$DisplayName is ready."
        } else {
            Write-Indeterminate-Bar "ERROR DETECTED"
            Write-Err "Task failed for $DisplayName (Exit Code: $exitCode)."
            if ($output) { Write-Host "  $($output.Trim())" -ForegroundColor DarkGray }
        }
    } catch {
        Write-Err "Critical Exception: $($_.Exception.Message)"
    }
}

function Get-Config {
    param([string]$FileName)
    $path = Join-Path $PSScriptRoot "..\assets\configs\$FileName"
    if (Test-Path $path) {
        return Get-Content $path -Raw | ConvertFrom-Json
    }
    Write-Err "Config not found: $FileName"
    return $null
}

function Open-Url {
    param([string]$Url, [string]$Label = "")
    if ($Label) { Write-Step "Opening: $Label" }
    Start-Process $Url
}

function Assert-Admin {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
    if (-not $isAdmin) {
        Write-Warn "Some features require Administrator rights."
        Write-Warn "Right-click the script and choose 'Run as Administrator'."
        return $false
    }
    return $true
}

