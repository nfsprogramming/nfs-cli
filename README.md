# NFS PROGRAMMER CLI 🚀

> A personal Windows bootstrapper, dev environment installer, gaming toolkit,
> driver updater, ISO hub, tweak manager, and power-user utility — all in one
> modular PowerShell CLI, by **Nifras**.

---

## ⚡ One-Line Install

```powershell
irm https://raw.githubusercontent.com/nifras/nfs-cli/main/install.ps1 | iex
```

---

## 🗂 Project Structure

```
nfs-cli/
│
├── install.ps1             ← Remote bootstrapper
├── main.ps1                ← Entry point
│
├── modules/
│   ├── helpers.ps1         ← Shared utilities
│   ├── scripts.ps1         ← System fixes & tools
│   ├── tools.ps1           ← App installer (browsers, media, utilities)
│   ├── devkit.ps1          ← Dev environment setup
│   ├── drivers.ps1         ← Auto-detect & install driver apps
│   ├── customapps.ps1      ← Personal picks + Spicetify
│   ├── gamesetup.ps1       ← Launchers, runtimes, perf tools
│   ├── isotools.ps1        ← OS tweaks, privacy, performance
│   ├── isos.ps1            ← Official OS download links
│   ├── mywebs.ps1          ← Quick-launch sites
│   └── about.ps1           ← Version info
│
├── assets/
│   ├── logo.txt
│   └── configs/
│       ├── apps.json       ← App catalog
│       ├── drivers.json    ← Driver detection rules
│       ├── isos.json       ← ISO link catalog
│       └── mywebs.json     ← Personal website list
│
└── README.md
```

---

## 🧩 Menu Overview

| # | Module       | What it does                                         |
|---|--------------|------------------------------------------------------|
| 1 | Scripts      | DNS flush, SFC repair, temp cleanup, WSL, Hyper-V   |
| 2 | Tools        | Browsers, media players, communication, utilities    |
| 3 | Dev Kit      | Python, Node, Git, VS Code, Docker, Flutter + more  |
| 4 | Driver Update| Auto-detect brand & GPU → install driver manager    |
| 5 | Custom Apps  | Hand-picked apps + Spicetify automation             |
| 6 | Game Setup   | Steam, Epic, VC++, .NET, DirectX, MSI Afterburner   |
| 7 | OS Tools     | Bloat removal, dark mode, privacy, restore points   |
| 8 | ISOs         | Official links to Windows, Ubuntu, Kali, etc.       |
| 9 | My Webs      | Quick-launch GitHub, AI tools, dev sites            |

---

## 🛠 Tech Stack

- **PowerShell** — Windows automation core
- **winget** — Official Microsoft package manager
- **JSON configs** — Modular, easy to extend
- **GitHub** — Hosting & one-line install

---

## ▶ Running Locally

```powershell
# Clone
git clone https://github.com/nifras/nfs-cli.git

# Run
cd nfs-cli
powershell -ExecutionPolicy Bypass -File main.ps1
```

---

## ✏ Customization

All menus are driven by JSON configs in `assets/configs/`:

- **`apps.json`** — Add/remove apps per category
- **`drivers.json`** — Add new OEM brands or GPU vendors
- **`isos.json`** — Add new OS ISO links
- **`mywebs.json`** — Your personal site list

---

## ⚠ Legal Notes

- Only **official winget packages** are used — no cracked software
- ISO links go to **official manufacturer pages only**
- The MAS link opens the **official massgrave.dev** website (no bundled activator)
- You are responsible for compliance with software licenses

---

## 🗺 Roadmap

| Phase | Goals                                                        |
|-------|--------------------------------------------------------------|
| v1.0  | Modular menu, app installers, OS tools, driver detection     |
| v2.0  | Auto-update via GitHub, config backup/restore, presets       |
| v3.0  | Terminal UI (TUI with colors/boxes), system benchmarking     |
| v4.0  | GUI version (WinForms or WPF), AI assistant inside CLI       |

---

*Built with ❤ by Nifras*
