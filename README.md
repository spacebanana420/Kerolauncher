# Kerolauncher

<p align="center">
<img src="keroppi.svg" width="150" />
</p>

Kerolauncher is a cross-platform CLI launcher for launching games and general programs. The launcher makes it fast and convenient to launch your programs and games from 1 source while also providing support for backups, custom commands, and more.

### Current features:
* Native execution of any software
* Launching any command you want
* Launching programs through Wine and Lutris (Unix-like)
* Launching programs with appimage-run or steam-run (NixOS)
* Extensive configuration
* Automatic and manual backups
* Error checking
* Config backup and restoration
* Out-of-the-box handy support for using emulators
* CLI arguments
* Simple file explorer for quick launchins
* Interactive menu (terminal user interface)
* High portability without clutter (doesn't write on .config, .local/share, AppData, etc)

<p align="center">
<img src="screenshot.png" width="600" />
</p>

# Download and how to use
## Requirements
* **Ruby**
  - Interpreter for Kerolauncher
* **Wine (optional)**
  - running Windows programs on Linux, MacOS, etc
* **Lutris (optional, Linux)**
  - launcher for Linux
* **xdg-utils (except Windows)**
  - Present in most OSes with a GUI. Uses the desktop's preferred program to open the file in question

## Download
Kerolauncher works on most operative systems and architectures, basically the ones supported by Ruby. Linux systems and Windows are officially tested, but MacOS, BSD systems, etc, should also be fine.

Kerolauncher is an interpreted program so it requires the Ruby interpreter to be installed to work (Recommended version 3.0.0 or higher).

Download Kerolauncher [from here](https://github.com/spacebanana420/Kerolauncher/releases) or from the repository directly (less stable).

## Install Ruby (Windows and MacOS)
Install Ruby [from the official website](https://www.ruby-lang.org/en/) and follow the instructions

## Install Ruby (Linux, BSD, etc)
Install Ruby from your native package manager

* Debian: ```apt install ruby```
* Arch: ```pacman -S ruby```
* openSUSE: ```zypper install ruby```
* NixOS: Add to your list of packages in your configuration.nix: ```ruby``` or whatever is latest (like ```ruby_3_2```)

## How to use
Launch Kerolauncher from a terminal with ```ruby kerolauncher.rb```, or just double-click kerolauncher.rb if you are on Windows.

Kerolauncher needs that you configure your games. Open config.rb in the config folder and set up your games.

# Configuration
Kerolauncher's configuration is located directly in config.rb, inside the config folder. Configuration for game names, game paths and backup paths is required.

Settings with [] mean that they support multiple entries. Each entry needs to be inside quotation marks and separated by commas, but they can be separated by lines as well, to make it easier to read.

Windows users can ignore everything related to Wine and Lutris
