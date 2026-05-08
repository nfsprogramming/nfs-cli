# ============================================================
#  NFS PROGRAMMER CLI - install.ps1
#  One-line remote bootstrapper
#  Usage: irm https://raw.githubusercontent.com/nifras/nfs-cli/main/install.ps1 | iex
# ============================================================

$ErrorActionPreference = "Stop"

$REPO   = "nifras/nfs-cli"
$BRANCH = "main"
$RAW    = "https://raw.githubusercontent.com/$REPO/$BRANCH"
$DEST   = "$env:USERPROFILE\nfs-cli"

Write-Host ""
Write-Host "  +-------------------------------------------------------+" -ForegroundColor Red
Write-Host "  |       NFS PROGRAMMER CLI - INSTALLER                 |" -ForegroundColor Red
Write-Host "  +-------------------------------------------------------+" -ForegroundColor Red
Write-Host ""
Write-Host "  Installing to: $DEST" -ForegroundColor Cyan
Write-Host ""

# -- Files to download -----------------------------------------
$files = @(
    "main.ps1",
    "modules/helpers.ps1",
    "modules/scripts.ps1",
    "modules/tools.ps1",
    "modules/devkit.ps1",
    "modules/drivers.ps1",
    "modules/customapps.ps1",
    "modules/gamesetup.ps1",
    "modules/isotools.ps1",
    "modules/isos.ps1",
    "modules/mywebs.ps1",
    "modules/about.ps1",
    "assets/logo.txt",
    "assets/configs/apps.json",
    "assets/configs/drivers.json",
    "assets/configs/isos.json",
    "assets/configs/mywebs.json"
)

$i = 0
foreach ($file in $files) {
    $i++
    $pct  = [int](($i / $files.Count) * 100)
    $dest = Join-Path $DEST $file
    $dir  = Split-Path $dest -Parent

    Write-Progress -Activity "NFS CLI Installer" -Status "Downloading $file" -PercentComplete $pct

    if (-not (Test-Path $dir)) { New-Item $dir -ItemType Directory -Force | Out-Null }

    try {
        Invoke-WebRequest "$RAW/$file" -OutFile $dest -UseBasicParsing
        Write-Host "  [OK] $file" -ForegroundColor Green
    } catch {
        Write-Host "  [X] Failed: $file" -ForegroundColor Red
    }
}

Write-Progress -Activity "NFS CLI Installer" -Completed

# -- Create desktop shortcut -----------------------------------
try {
    $shortcutPath = "$env:USERPROFILE\Desktop\NFS CLI.lnk"
    $wsh  = New-Object -ComObject WScript.Shell
    $link = $wsh.CreateShortcut($shortcutPath)
    $link.TargetPath       = "powershell.exe"
    $link.Arguments        = "-NoExit -ExecutionPolicy Bypass -File `"$DEST\main.ps1`""
    $link.WorkingDirectory = $DEST
    $link.Description      = "NFS Programmer CLI"
    $link.Save()
    Write-Host ""
    Write-Host "  [OK] Desktop shortcut created: NFS CLI.lnk" -ForegroundColor Green
} catch {
    Write-Host "  [!] Could not create desktop shortcut." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "  ----------------------------------------------------" -ForegroundColor DarkRed
Write-Host "  Installation complete!" -ForegroundColor Red
Write-Host "  Run with:  powershell -ExecutionPolicy Bypass -File `"$DEST\main.ps1`"" -ForegroundColor White
Write-Host "  Or double-click 'NFS CLI' on your Desktop." -ForegroundColor White
Write-Host "  ----------------------------------------------------" -ForegroundColor DarkRed
Write-Host ""

# -- Auto-launch -----------------------------------------------
$launch = Read-Host "  Launch NFS CLI now? (Y/N)"
if ($launch.ToUpper() -eq "Y") {
    & "$DEST\main.ps1"
}
