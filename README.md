# Kerolauncher
Kerolauncher is a cross-platform CLI launcher for launching games and general programs. The launcher makes it fast and convenient to launch your programs and games from 1 source while also providing support for backups, custom commands, and more. The main target operative systems are Linux-based operative systems and Windows.

You can play native games or use Wine, Lutris or even emulators!

### Current supported consoles:
* DS/DSi
* 3DS/2DS
* Wii
* SNES

Wine is exclusive to non-Windows systems and Lutris is exclusive to Linux and other systems that support it, every other feature is system-agnostic

For NixOS, you also have support for steam-run and appimage-run


# How to use
Download kerolauncher.rb and (if you haven't yet) [install Ruby on your system](https://www.ruby-lang.org/en/) (Recommended >=3.1.0). Kerolauncher is an interpreted program so it requires the Ruby interpreter to work.

If you are on Linux/MacOS/BSD/etc and you want to play Windows-exclusive games, you also require wine to play and optionally Lutris.

Open kerolauncher.rb and change the configuration settings, this setup is required.

After everything is configured, you can execute the launcher from a terminal with ```ruby kerolauncher.rb```.

# Configuration
Kerolauncher's configuration is located directly in config.rb, inside the config folder. Configuration for game names, game paths and backup paths is required.

Settings with [] mean that they support multiple entries. Each entry needs to be inside quotation marks and separated by commas, but they can be separated by lines as well, to make it easier to read.

Windows users can ignore everything related to Wine and Lutris

## $games, $wine_games and $lutris_games
**Add the names of your game entries here**

*Example: $games = ["Minecraft", "Touhou 12", "VLC Media Player"]*

## $game_paths and $wine_paths
**The paths to the games' executables**

In case of $wine_paths entries, the games will be executed with Wine, to add support for Windows-only programs on other operative systems

*Example (Unix-like): $game_paths = ["~/Games/Garry's Mod/hl2"]*

*Example (Windows): $game_paths = ["C:/Games/Touhou 10/th10.exe"]*

**Note for Windows users:** Windows might use the backslash ```"\"``` for paths, but to not mess up text formatting, both Ruby and my program use ```"/"``` and you should add your directories with the forward slash instead 

## $lutris_games_id
**Add the Lutris games's IDs here**

You can find out which ID each Lutris entry has by typing ```lutris -l``` on the terminal

## $emulated_games
**Add the names of your console games**

## $emulated_game_paths
**Add the path to the respective ROMs of your games**

The file extension will determine what console the game is from!

Supported formats: ```.nds .cia .cci .3ds .wbfs .sfc```

## $backup_paths
**Add the path to a file or folder to backup**

Warning: If you add a folder, every single file and folder inside it will be copied, so be careful adding huge folders to the entries

## $backup_destination
**The destination to where the backups of paths go**

If this destination is not set or does not exist, it defaults to wherever the working directory of the terminal session was

## $auto_backup
**If the launcher should start the backup process after you close the game you were playing**

Can be set to ```true``` or ```false```

## $start_command and $close_command
**A custom command to launch before and starting a game, respectively**

*Example: ```sudo cpupower frequency-set -g performance```*

## $ascii_art
**The ascii art to be displayed when launching Kerolauncher** 

Any text can replace the art

Replace with "" to disable
