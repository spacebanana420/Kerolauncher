# Kerolauncher
Kerolauncher is a cross-platform CLI launcher for launching games and general programs. The launcher makes it fast and convenient to launch your programs and games from 1 source while also providing support for backups, custom commands, and more.

Kerolauncher works on nearly all operative systems, as long as they support the Ruby interpreter, but there are some features that are exclusive to Linux.

You can play native games or use Wine, Lutris and even conveniently launch emulators.

### Out of the box support for using emulators for:
* DS/DSi
* 3DS/2DS
* Wii
* SNES
* GBA
* Custom system

For the convenience of NixOS users, you also have support for steam-run and appimage-run

# Download and how to use
## Download
Download Kerolauncher [from here](https://github.com/spacebanana420/Kerolauncher/releases) or from the repository directly (less stable) and, if you haven't yet, [install Ruby on your system](https://www.ruby-lang.org/en/) (Recommended >=3.1.0). Kerolauncher is an interpreted program so it requires the Ruby interpreter to work.

If you are on Linux/MacOS/BSD/etc and you want to play Windows-exclusive games, you also require Wine to play and optionally Lutris.

## How to use
Open config.rb in the config folder and set up your games, this setup is required.

After everything is configured, you can execute the launcher from a terminal with ```ruby kerolauncher.rb```.

# Configuration
Kerolauncher's configuration is located directly in config.rb, inside the config folder. Configuration for game names, game paths and backup paths is required.

Settings with [] mean that they support multiple entries. Each entry needs to be inside quotation marks and separated by commas, but they can be separated by lines as well, to make it easier to read.

Windows users can ignore everything related to Wine and Lutris
