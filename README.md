<div align="center">

```
 __  __    _    ____   ____ _   _    _    _   _  ____ _____ ____  
|  \/  |  / \  / ___| / ___| | | |  / \  | \ | |/ ___| ____|  _ \ 
| |\/| | / _ \| |     | |   | |_| | / _ \ |  \| | |  _|  _| | |_) |
| |  | |/ ___ \ |___  | |___|  _  |/ ___ \| |\  | |_| | |___|  _ < 
|_|  |_/_/   \_\____|  \____|_| |_/_/   \_\_| \_|\____|_____|_| \_\
```

### automatic MAC address rotation for pentest engagements & lab environments

[![Shell](https://img.shields.io/badge/shell-bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/platform-linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)](#requirements)
[![License](https://img.shields.io/badge/license-MIT-blue?style=for-the-badge)](#license)
[![Status](https://img.shields.io/badge/status-active-brightgreen?style=for-the-badge)](#)

<br>

[![Get Started](https://img.shields.io/badge/▶_get_started-000000?style=for-the-badge)](#usage)
[![Features](https://img.shields.io/badge/★_features-000000?style=for-the-badge)](#features)
[![Configuration](https://img.shields.io/badge/⚙_configuration-000000?style=for-the-badge)](#configuration)

<div align="center">
<br>

<img width="541" height="372" alt="Screenshot 2026-08-11 at 9 35 03 PM" src="https://github.com/user-attachments/assets/05305482-21b6-4e97-ae4b-c0083c2a280b" />

## Why

MAC address rotation is a common technique in **authorized** penetration testing and red team engagements for:

- **Evading MAC-based access controls** — testing whether a network's port security, NAC (network access control), or MAC filtering can be bypassed, and documenting the finding for the client.
- **Avoiding trivial correlation during recon** — over an extended, authorized engagement window, rotating the MAC prevents a single address from being an easy pivot point for blue team log correlation.
- **Simulating rogue device behavior** — testing whether a network can detect and respond to a device that keeps changing its layer-2 identity, a known technique in real intrusions.
- **Lab and training environments** — practicing against NAC/802.1X setups, isolated CTF ranges, or home lab gear without manually running `macchanger` on a timer.

> [!IMPORTANT]
> This tool is intended for use only on networks and systems you own or are explicitly authorized to test (e.g. under a signed engagement scope or written permission). Unauthorized MAC spoofing on networks you don't control may violate computer misuse laws and your engagement's rules of engagement if used outside scope.

<br>

## Features

<div align="center">

| | |
|---|---|
| 🔄 | Rotates the MAC on `eth0` *(configurable)* every 60s *(configurable)* via `macchanger -r` |
| 📟 | Live terminal dashboard with a real-time countdown to the next rotation |
| 🕓 | Tracks every MAC used this session — old ones are flagged `[expired]` |
| 🧬 | Captures your original hardware MAC before anything changes |
| ↩️ | Auto-restores the original MAC when you stop the script |

</div>

<br>

## Requirements

```
Linux
macchanger      → sudo apt install macchanger
sudo privileges → interface changes require root
```

<br>

## Usage

```bash
chmod +x mac_rotator.sh
./mac_rotator.sh
```

Press `Ctrl+C` to stop — the script brings the interface down, restores your original MAC, and brings it back up before exiting.

<br>

## Configuration

Edit the variables at the top of the script:

```bash
INTERFACE="eth0"   # network interface to target
INTERVAL=60        # seconds between rotations
```

<br>

## Caveats

> [!WARNING]
> `Ctrl+C` (SIGINT) and a standard `kill` (SIGTERM) are handled and will restore your original MAC. A `kill -9` (SIGKILL) or a system crash **cannot** be trapped by any script. If that happens, restore manually:
> ```bash
> sudo ip link set <interface> down
> sudo ip link set <interface> address <original_mac>
> sudo ip link set <interface> up
> ```

Some NICs or drivers restrict which MAC bits can be changed (locally administered bit, vendor-locked firmware, etc.) — `macchanger` will report if a change fails.

<br>

<div align="center">

## License

MIT

</div>
