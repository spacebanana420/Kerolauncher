# Kerolauncher
Kerolauncher is a cross-platform CLI launcher for playing Touhou and configuring save data. The main target operative systems are Linux-based operative systems and Windows.

For Linux, Kerolauncher supports Wine or Lutris to launch the games, while for Windows it executes the game natively (of course). Every other feature is system-agnostic.

MacOS and BSD-based systems are not supported by Lutris

**Note:** Kerolauncher is still in testing phase and, until version 0.1 is out, the code available in this repository will be unfinished and unstable. It surely has many bugs to be encountered or design choices to be changed, so I welcome all bug reports or feature requests!

# How to use
Download kerolauncher.rb and (if you haven't yet) install Ruby on your system. Kerolauncher is an interpreted program so it requires the Ruby interpreter to work.

If you are on Linux/MacOS/BSD/etc, you also require wine to play and optionally Lutris to integrate the launcher with Lutris

Open kerolauncher.rb and explore the configuration settings, this setup is required

After everything is configured, you can execute the launcher from a terminal with ```ruby kerolauncher.rb```
