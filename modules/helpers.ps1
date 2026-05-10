# ============================================================
#  NFS CLI - helpers.ps1
#  Shared utility functions used across all modules
# ============================================================

function Write-Success { param($msg) Write-Host "  [OK] $msg" -ForegroundColor Green }
function Write-Info { param($msg) Write-Host "  [i]  $msg" -ForegroundColor Cyan }
function Write-Warn { param($msg) Write-Host "  [!]  $msg" -ForegroundColor Yellow }
function Write-Err { param($msg) Write-Host "  [X]  $msg" -ForegroundColor Red }
function Write-Step { param($msg) Write-Host "`n  >> $msg" -ForegroundColor White }

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

function Show-Intro {
    Clear-Host
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    
    # 1. Glitch / Matrix Entrance
    $chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#%^&*()_+-=[]{}|;:,.<>?"
    for ($i = 0; $i -lt 12; $i++) {
        $glitchLine = ""
        for ($j = 0; $j -lt 70; $j++) { $glitchLine += $chars[(Get-Random -Maximum $chars.Length)] }
        Write-Host "  $glitchLine" -ForegroundColor ([Enum]::GetValues([ConsoleColor]) | Get-Random)
        Start-Sleep -Milliseconds 10
    }
    Clear-Host

    # 2. System Architecture Readout
    $os = (Get-WmiObject Win32_OperatingSystem).Caption
    $arch = $env:PROCESSOR_ARCHITECTURE
    $ram = [Math]::Round((Get-WmiObject Win32_PhysicalMemory | Measure-Object Capacity -Sum).Sum / 1GB, 0)
    
    Write-Host "`n  [SYSTEM_DIAGNOSTIC]" -ForegroundColor DarkRed
    Write-Host "  > OS_KERNEL : $os" -ForegroundColor White
    Write-Host "  > ARCH_TYPE : $arch" -ForegroundColor White
    Write-Host "  > MEM_STACK : $ram GB PHYSICAL" -ForegroundColor White
    Write-Host "  > STATUS    : [READY]" -ForegroundColor Green
    Start-Sleep -Milliseconds 800
    Clear-Host

    # 3. Scanning Logo Entrance
    $logoPath = Join-Path (Split-Path $PSScriptRoot -Parent) "assets\logo.txt"
    if (Test-Path $logoPath) {
        $logoLines = Get-Content $logoPath -Encoding utf8
        
        # Scanning Line Animation
        for ($scan = 0; $scan -lt $logoLines.Count; $scan++) {
            Clear-Host
            for ($i = 0; $i -lt $logoLines.Count; $i++) {
                if ($i -eq $scan) {
                    Write-Host "  $($logoLines[$i]) << [SCANNING]" -ForegroundColor White
                }
                elseif ($i -lt $scan) {
                    Write-Host "  $($logoLines[$i])" -ForegroundColor Red
                }
                else {
                    Write-Host "  $($logoLines[$i])" -ForegroundColor DarkGray
                }
            }
            Start-Sleep -Milliseconds 30
        }
    }
    
    Write-Host ""
    $text = "  >> INJECTING NFS_SUPREME_KERNEL_V3 [OVERCLOCK_MODE]..."
    $colors = @("DarkRed", "Red", "White")
    
    foreach ($char in $text.ToCharArray()) {
        Write-Host $char -NoNewline -ForegroundColor ($colors | Get-Random)
        Start-Sleep -Milliseconds (Get-Random -Minimum 3 -Maximum 15)
    }
    Start-Sleep -Milliseconds 200
    
    Write-Host "`n  >> SYNCHRONIZING CORE CLOCKS..." -ForegroundColor DarkGray
    for ($i = 0; $i -le 100; $i += 20) {
        Write-NFSProgress "Overclock" $i
        Start-Sleep -Milliseconds 50
    }
}

function Show-Login {
    while ($true) {
        Clear-Host
        $logoPath = Join-Path (Split-Path $PSScriptRoot -Parent) "assets\logo.txt"
        if (Test-Path $logoPath) {
            Get-Content $logoPath -Encoding utf8 | ForEach-Object { Write-Host "  $_" -ForegroundColor DarkRed }
        }
        
        Write-Host ""
        Write-Host "  +=====================================================+" -ForegroundColor Red
        Write-Host "  | [!] SECURITY CLEARANCE REQUIRED : LEVEL 5 ACCESS    |" -ForegroundColor Red
        Write-Host "  +=====================================================+" -ForegroundColor Red
        Write-Host ""
        
        Write-Host "  >> ATTEMPTING ACCESS FROM: $($env:COMPUTERNAME)" -ForegroundColor DarkGray
        Write-Host "  >> SYSTEM TIMESTAMP: $(Get-Date -Format 'HH:mm:ss')" -ForegroundColor DarkGray
        Write-Host ""
        
        # Biometric Simulation
        Write-Host "  [SCANNING BIOMETRICS] " -NoNewline -ForegroundColor White
        $block = [char]0x2588
        for ($i = 0; $i -lt 15; $i++) {
            Write-Host $block -NoNewline -ForegroundColor Red
            Start-Sleep -Milliseconds (Get-Random -Minimum 20 -Maximum 80)
        }
        Write-Host " [MATCH]" -ForegroundColor Green
        Write-Host ""

        Write-Host "  IDENTIFIER : " -NoNewline -ForegroundColor White
        $enteredUser = Read-Host
        
        Write-Host "  PASS-CODE  : " -NoNewline -ForegroundColor White
        $enteredPass = Read-Host -AsSecureString
        $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($enteredPass)
        $enteredPassPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto($ptr)
        [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr)

        Write-Host ""
        Write-Indeterminate-Bar "AUTH_SEQUENCING"
        Start-Sleep -Milliseconds 800

        if ($enteredUser.Trim().ToUpper() -eq "NFS" -and $enteredPassPlain -eq "2GdwEMEyhPp@4UQ") {
            Write-Success "IDENTITY CONFIRMED. Access granted to NFS."
            Start-Sleep -Milliseconds 1200
            return $true
        }
        else {
            Write-Err "CREDENTIAL MISMATCH. Unauthorized attempt logged."
            Start-Sleep -Milliseconds 2000
        }
    }
}

function Pause-Menu {
    Write-Host ""
    Write-Host "  Press any key to return to the menu..." -ForegroundColor DarkGray
    try {
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    } catch {
        $null = Read-Host
    }
}

function Confirm-Back {
    Write-Host ""
    Write-Host "  [B] Back   [Q] Quit" -ForegroundColor DarkGray
    $k = Read-Host "  >"
    return $k.Trim().ToUpper()
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

function Refresh-Explorer {
    $code = '[DllImport("shell32.dll")] public static extern void SHChangeNotify(uint wEventId, uint uFlags, IntPtr dwItem1, IntPtr dwItem2);'
    $type = Add-Type -MemberDefinition $code -Name "Shell32" -Namespace "WinAPI" -PassThru
    $type::SHChangeNotify(0x08000000, 0x0000, [IntPtr]::Zero, [IntPtr]::Zero)
}

function Assert-Winget {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Err "Winget is not installed. Please install App Installer from Microsoft Store."
        return $false
    }
    return $true
}

function Install-WingetApp {
    param([string]$DisplayName, [string]$WingetId)
    if ([string]::IsNullOrWhiteSpace($WingetId)) {
        Write-Err "Invalid Winget ID for $DisplayName."
        return
    }
    $esc = [char]27
    Write-Host "$($esc)[48;2;0;0;0m" -NoNewline 
    Write-Step "SYSTEM TASK: Processing $DisplayName ($WingetId)"
    
    try {
        $cmd = if ($DisplayName -like "*Updating*") { "upgrade" } else { "install" }
        $tempFile = New-TemporaryFile
        $process = Start-Process winget -ArgumentList "$cmd --id $WingetId -e --accept-source-agreements --accept-package-agreements --silent" -PassThru -NoNewWindow -RedirectStandardOutput $tempFile.FullName -ErrorAction Stop
        
        $p = 0
        while (-not $process.HasExited) {
            if ($p -lt 95) { $p += 1 }
            Write-NFSProgress "Working" $p
            Start-Sleep -Milliseconds 200
        }
        
        $exitCode = $process.ExitCode
        $output = Get-Content $tempFile.FullName -Raw
        Remove-Item $tempFile.FullName -ErrorAction SilentlyContinue
        
        $isSuccess = ($exitCode -eq 0) -or ($output -like "*Successfully installed*") -or ($output -like "*already installed*")
        
        if ($isSuccess) {
            Write-NFSProgress "Success" 100
            Write-Success "$DisplayName is ready."
        } else {
            Write-Err "Task failed for $DisplayName (Exit Code: $exitCode)."
        }
    } catch {
        Write-Err "Critical Exception: $($_.Exception.Message)"
    }
}

function Get-Config {
    param([string]$FileName)
    $configPath = Join-Path (Split-Path $PSScriptRoot -Parent) "assets\configs\$FileName"
    if (-not (Test-Path $configPath)) {
        Write-Err "Config file not found: $configPath"
        return $null
    }
    try {
        return Get-Content $configPath -Raw | ConvertFrom-Json
    } catch {
        Write-Err "Failed to parse $FileName. Check JSON syntax."
        return $null
    }
}

function Open-Url {
    param([string]$Url, [string]$Label = "")
    if ($Label) { Write-Step "Opening: $Label" }
    Start-Process $Url
}
