# potentpi6

![Build Status](https://github.com/OnyxJeff/potentpi6/actions/workflows/build.yml/badge.svg)
![Maintenance](https://img.shields.io/maintenance/yes/2026.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![GitHub release](https://img.shields.io/github/v/release/OnyxJeff/potentpi6)
![Issues](https://img.shields.io/github/issues/OnyxJeff/potentpi6)

**DashPi** turns a Raspberry Pi 4b - 4GB into a tiny, stubbornly reliable fullscreen dashboard device. It does exactly one job — displaying your dashboard — and refuses to complain about it.

## 📁 Repo Structure

```text
potentpi6/
├── .github/workflows/      # CI for YAML validation
├── backup_logs/            # Archived logs from update scripts
├── config/                 # Configuration files (DakBoard URL, refresh interval, WiFi watchdog)
├── logs/                   # Most recent runtime/update logs
├── scripts/                # Setup, kiosk launcher, WiFi watchdog, updater
├── systemd/                # Systemd service files for kiosk and WiFi watchdog
└── README.md               # You're reading it!
```

---

## 🧰 Services Included
- Chromium Fullscreen Kiosk
  - Boots straight into your DakBoard URL (or any dashboard) in fullscreen.
  - Auto-restarts via systemd if it crashes.
- WiFi Watchdog
  - Checks connectivity and restarts ```wlan0``` if your network becomes unreachable.
- Auto-Updater Script (optional)
  - Updates OS packages and logs results weekly/monthly.

---

## 📝 Preparation

  - Install GIT (app used to download this repo onto your device)
  ```bash
  sudo apt install git -y
  ```

  - Download repo
  ```bash
  cd
  git clone https://github.com/OnyxJeff/potentpi6.git
  ```

---

## ⚠️ Updating the OS

- Make the log folder for updates
```bash
mkdir ~/potentpi6/logs
mkdir ~/potentpi6/backup_logs
```

- Update and Upgrade the System via script:
```bash
cd ~/potentpi6/scripts
chmod +x apt-get-autoupdater.sh
sudo ./apt-get-autoupdater.sh
```
It's going to look like this froze, but just let it go.

- Start CronJob (optional but recommended if doing headless/always on installation)
```bash
sudo crontab -e
```

  - add the following to the bottom of the document:
  ```bash
  # OS-Auto-Updater
    00 01 * * 0 bash $HOME/potentpi6/scripts/apt-get-autoupdater.sh
      # execute automatic update script and log every sunday at 01:00 am
    50 00 1 * * /bin/bash -c 'cp $HOME/potentpi6/logs/apt-get-autoupdater.log $HOME/potentpi6/backup_logs/apt-get-autoupdater-$(date +\%Y\%m\%d).log'
      # saves monthly version of "apt-get-autoupdater.log" on the 1st of every month at 00:50 am
    51 00 1 * * rm -f $HOME/potentpi6/logs/apt-get-autoupdater.log
      # deletes old weekly log on the 1st of every month at 00:51 am
  ```

---

## 📦 Installing Docker Compose

- Install Docker
```bash
cd
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

- Add User to Docker Group
```bash
sudo usermod -aG docker $USER
```

> [!IMPORTANT]
> After running this command you will need to log out and log back in (or I recommend just rebooting) for the changes to take effect.

- Install Docker Compose:
```bash
sudo apt install docker-compose-plugin
```

- Verify Installation:
```bash
docker run hello-world
docker compose version
```

### 📝 Installing your first container(s)

- Installing Container Stack (via script)
```bash
cd ~/potentpi6/scripts
chmod +x docker-up-all.sh
./docker-up-all.sh
```

---

## 🛠️ Configuration
### ➤ Installation

- On the desktop (using RPi connect or VNC) manually change the resolution to 1080p (or your displays native resolution)

- Run setup (installs Chromium, kiosk desktop service, WiFi watchdog)
```bash
cd ~/potentpi6/scripts
chmod +x setup.sh
sudo ./setup.sh
```
> This runs scripts/configs, sets up systemd services for WiFi watchdog, reboots the device, and starts the kiosk automatically.

### 🧹 Uninstalling
```bash
cd ~/potentpi6/scripts
chmod +x uninstall.sh
sudo ./uninstall.sh
```

- This will remove:
  - systemd services
  - installed scripts and configs
  - kiosk auto-start
  - WiFi watchdog monitor

### ➤ DakBoard URL

- Edit:
```bash
sudo nano /usr/local/dashpi/config/url.txt.example
```

Paste in your private DakBoard share URL and save as ```url.txt```

### ➤ Refresh Interval

- Edit:
```bash
sudo nano /usr/local/dashpi/config/refresh.txt.example
```

Specify minutes (e.g., 15) and save as ```refresh.txt```

### ➤ WiFi Watchdog Settings

- Edit:
```bash
sudo nano /usr/local/dashpi/config/wifi-watchdog.conf
```

Set interface name and ping target.

---

## Acknowledgements

This project uses or is inspired by:
- [Chromium](https://www.raspberrypi.com/software/) – Fullscreen kiosk browser
- [DAKboard](https://dakboard.com/site) – Dashboard service displayed on the kiosk
- [Raspberry Pi Forums](https://forums.raspberrypi.com/viewtopic.php?t=40860) – Community kiosk tips

---

📬 Maintained By
Jeff M. • [@OnyxJeff](https://www.github.com/onyxjeff)