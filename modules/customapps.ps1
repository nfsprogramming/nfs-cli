# ============================================================
#  NFS CLI - customapps.ps1
#  Your personal hand-picked app collection
# ============================================================
. "$PSScriptRoot\helpers.ps1"

function Show-CustomAppsMenu {
    while ($true) {
        Clear-Host
        Write-Section "CUSTOM APPS"
        Write-Host ""
        Write-Host "  -- Pro User Tools -------------------------------------" -ForegroundColor DarkYellow
        Write-Host "   1.  Windhawk (OS Modding)   2.  Spacedesk (Monitor)" -ForegroundColor Cyan
        Write-Host "   3.  Rainmeter (Desktop)     4.  Notion (Workspace)" -ForegroundColor Cyan
        Write-Host "   5.  Telegram Desktop        6.  Wise Uninstaller"   -ForegroundColor Cyan
        Write-Host "   7.  AnyDesk (Remote)        8.  CrystalDiskMark"    -ForegroundColor Cyan
        Write-Host "   9.  Photoshop (Official)    10. Mechvibes (Sound)"   -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  -- Standard Picks -------------------------------------" -ForegroundColor DarkYellow
        Write-Host "  11.  Google Chrome           12. WhatsApp"           -ForegroundColor Cyan
        Write-Host "  13.  Spotify                 14. LocalSend"          -ForegroundColor Cyan
        Write-Host "  15.  Obsidian                16. Bitwarden"          -ForegroundColor Cyan
        Write-Host "  17.  qBittorrent             18. Everything Search"  -ForegroundColor Cyan
        Write-Host "  19.  ShareX (Screenshots)"                            -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  B.  Back" -ForegroundColor DarkGray
        Write-Host ""
        $choice = (Read-Host "  Select").Trim().ToUpper()

        switch ($choice) {
            "1"  { Install-WingetApp "Windhawk"              "Windhawk.Windhawk" }
            "2"  { Install-WingetApp "Spacedesk"              "datavideo.spacedesk" }
            "3"  { Install-WingetApp "Rainmeter"             "Rainmeter.Rainmeter" }
            "4"  { Install-WingetApp "Notion"                "Notion.Notion" }
            "5"  { Install-WingetApp "Telegram"              "Telegram.TelegramDesktop" }
            "6"  { Install-WingetApp "Wise Uninstaller"      "Wise.WiseProgramUninstaller" }
            "7"  { Install-WingetApp "AnyDesk"               "AnyDeskSoftwareGmbH.AnyDesk" }
            "8"  { Install-WingetApp "CrystalDiskMark"       "CrystalDewWorld.CrystalDiskMark" }
            "9"  { Open-Url "https://www.adobe.com/products/photoshop.html" "Adobe Photoshop" }
            "10" { Install-WingetApp "Mechvibes"             "Mechvibes.Mechvibes" }
            "11" { Install-WingetApp "Google Chrome"         "Google.Chrome" }
            "12" { Install-WingetApp "WhatsApp"              "WhatsApp.WhatsApp" }
            "13" { Install-WingetApp "Spotify"               "Spotify.Spotify" }
            "14" { Install-WingetApp "LocalSend"              "LocalSend.LocalSend" }
            "15" { Install-WingetApp "Obsidian"               "Obsidian.Obsidian" }
            "16" { Install-WingetApp "Bitwarden"              "Bitwarden.Bitwarden" }
            "17" { Install-WingetApp "qBittorrent"            "qBittorrent.qBittorrent" }
            "18" { Install-WingetApp "Everything"             "voidtools.Everything" }
            "19" { Install-WingetApp "ShareX"                 "ShareX.ShareX" }
            "B"  { return }
            default { Write-Warn "Invalid option." ; Start-Sleep 1 }
        }
        Pause-Menu
    }
}

