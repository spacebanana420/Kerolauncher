# Kerolauncher
Kerolauncher is a cross-platform CLI launcher for launching games and non-game programs. The launcher makes it fast and convenient to launch your programs and games from 1 source while also providing support for backups, custom commands, and more. The main target operative systems are Linux-based operative systems and Windows.

For Linux, Kerolauncher has support for Wine and Lutris to launch the games, while for Windows it only has support to execute the game natively. Every other feature is system-agnostic.

MacOS and BSD-based systems are not supported by Lutris

**Note:** Kerolauncher is still in testing phase and, until version 0.1 is out, the code available in this repository will be unfinished and unstable. It surely has many bugs to be encountered or design choices to be changed, so I welcome all bug reports or feature requests!

# How to use
Download kerolauncher.rb and (if you haven't yet) [install Ruby on your system](https://www.ruby-lang.org/en/). Kerolauncher is an interpreted program so it requires the Ruby interpreter to work.

If you are on Linux/MacOS/BSD/etc and you want to play Windows-exclusive games, you also require wine to play and optionally Lutris.

Open kerolauncher.rb and change the configuration settings, this setup is required.

After everything is configured, you can execute the launcher from a terminal with ```ruby kerolauncher.rb```.

# Configuration
Kerolauncher's configuration is located directly inside the program file. Configuration is mandatory as you need to add your games manually there for now

Settings with [] mean that they support multiple entries. Each entry needs to be inside quotation marks and separated by commas, but they can be separated by lines as well, to make it easier to read.

Windows users can ignore anything related to Wine and Lutris

## $games, $wine_games and $lutris_games
**Add the names of your game entries here**

*Example: $games = ["Minecraft", "Touhou 12", "VLC Media Player"]*

## $game_paths and $wine_paths
**The paths to the games' executables**

*Example (Unix-like): $game_paths = ["~/Games/Garry's Mod/hl2"]*

*Example (Windows): $game_paths = ["C:\Games\Touhou 10\th10.exe"]*

## $lutris_games_id
**Add the Lutris games's IDs here**

You can find out which ID each Lutris entry has by typing ```lutris -l``` on the terminal

## $backup_paths
**Add the path to a file or folder to backup**

## $backup_destination
**The destination to where the backups of paths go**

If this destination is not set or does not exist, it defaults to wherever the working directory of the terminal session was

## $global_command
**A custom command to launch before starting a game**

*Example ```sudo cpupower frequency-set -g performance```*

## $ascii_art
**The ascii art to be displayed when launching Kerolauncher** 

Any text can replace the art

Replace with "" to disable
