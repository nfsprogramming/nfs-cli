# ============================================================
#  NFS CLI - wallpaper.ps1
#  Desktop Aesthetic Management
# ============================================================
. "$PSScriptRoot\helpers.ps1"

function Show-WallpaperMenu {
    $wallDir = Join-Path $PSScriptRoot "..\" "Desktop Wallpapers...🖥️"
    
    if (-not (Test-Path $wallDir)) {
        Write-Warn "Wallpaper directory not found."
        Pause-Menu
        return
    }

    while ($true) {
        Clear-Host
        Write-Section "DESKTOP WALLPAPER SELECTOR"
        Write-Host ""
        
        $walls = Get-ChildItem -Path $wallDir -Include *.jpg, *.jpeg, *.png -File
        
        if ($walls.Count -eq 0) {
            Write-Warn "No wallpapers found in the folder."
            Pause-Menu
            return
        }

        Write-Host "  Found $($walls.Count) wallpapers in your collection." -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  1.  List and Set Wallpaper"
        Write-Host "  2.  Random Wallpaper"
        Write-Host "  3.  Open Wallpaper Folder"
        Write-Host ""
        Write-Host "  B.  Back" -ForegroundColor DarkGray
        Write-Host ""

        $choice = (Read-Host "  Select").Trim().ToUpper()

        switch ($choice) {
            "1" {
                $i = 1
                foreach ($wall in $walls) {
                    Write-Host "  [$i] $($wall.Name)" -ForegroundColor White
                    $i++
                    if ($i -gt 20) { Write-Host "  ... and more" -ForegroundColor DarkGray; break }
                }
                Write-Host ""
                $idx = Read-Host "  Enter number to set (or B to cancel)"
                if ($idx -eq "B") { continue }
                if ([int]::TryParse($idx, [ref]$val) -and $val -le $walls.Count) {
                    Set-WallPaper $walls[$val-1].FullName
                }
            }
            "2" {
                $rand = Get-Random -InputObject $walls
                Set-WallPaper $rand.FullName
            }
            "3" {
                Start-Process explorer.exe $wallDir
            }
            "B" { return }
        }
    }
}

function Set-WallPaper {
    param([string]$Path)
    Write-Info "Setting wallpaper: $(Split-Path $Path -Leaf)"
    
    $code = @'
    using System;
    using System.Runtime.InteropServices;
    public class Wallpaper {
        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
        public const int SPI_SETDESKWALLPAPER = 20;
        public const int SPIF_UPDATEINIFILE = 0x01;
        public const int SPIF_SENDWININICHANGE = 0x02;
        public static void Set(string path) {
            SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, path, SPIF_UPDATEINIFILE | SPIF_SENDWININICHANGE);
        }
    }
'@
    Add-Type -TypeDefinition $code -ErrorAction SilentlyContinue
    [Wallpaper]::Set($Path)
    Write-Success "Wallpaper applied successfully!"
    Start-Sleep -Seconds 1
}
