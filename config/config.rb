#This is the entire configuration of the program. Manual setup is required from here for setting up the games.
#All text settings that support multiple entries need to be between quotation marks, and multiple text strings (inside []) need to be separated by commas
#Each entry can be separated between lines, as long as they are inside the brackets and a comma separates them

#The use of Lutris is only available to operative systems supported by the program, such as Linux
#Non-Windows systems require Wine to be installed in order to launch Windows executables

$games = []
#Add the names for your native programs here
#Example: $games = ["Touhou 16", "A Hat in Time", "Blender", "Super Mario 64"]

$game_paths = []
#The path(s) to the games' executables, same order as above
#The programs in this list need to be native to your operative system
#Example: $game_paths = ["/path/to/game.exe", "/path/to/another/game.exe"]


$wine_games = []
#Add the names for your programs that you want to execute with Wine, just like $games

$wine_game_paths = []
#Add the paths for the said programs above
#Example: $wine_game_paths = ["/path/to/game.exe", "/path/to/another/game.exe"]


$lutris_games = []
#Add the names for Lutris entries here to be displayed

$lutris_games_id = []
#The Lutris entry ID for the same programs above at the same order
#To know which ID your game entries are assigned to, launch "lutris -l" in the terminal

$lutris_command = "lutris rungameid/"
#The command to launch lutris with a game ID
#You can change it for broader support. Example: "flatpak run net.lutris.Lutris rungameid/"

$command_names = []
#The names of the commands to display
#Example: $command_names = ["Update system", "Tomodachi Life"]

$command_programs = []
#List of your commands that can be executed
#Example: $command_programs = ["sudo dnf upgrade", "citra '/games/Tomodachi Life.3ds'"]


$emulated_games = []
#Add the name of your console games
#Example: $emulated_games = ["Super Mario World", "Super Smash Bros Brawl"]

$emulated_game_paths = []
#The path to the roms of the respective games above
#File extension determines the console! If the ROM file is not "supported", it will be attempted to be launched with $custom_emu_command
#Supported formats:
    #.nds
    #.cia, .cci, .3ds
    #.wbfs
    #.gba
    #.sfc

#The commands for launching emulators when executing ROMs
#Example: "melonds" or "/path/to/melonds" or "flatpak run net.kuribo64.melonDS"
#If left empty, the commands will default to what they originally were
$nds_command = "melonds" #DS and DSi
$threeds_command = "citra" #3DS and 2DS
$wii_command = "dolphin-emu" #Wii
$gba_command = "mgba" #GBA
$snes_command = "snes9x" #SNES

$custom_emu_command = "" #Custom command to launch the file with
#You can use this to add console emulation that isn't supported out of the box




$backup_paths = []
#The path to the folders or files that you want to back up

$backup_destination = ""
#The path to where the backed up folders and files go
#If it's empty or non-existant, it will default to the path where the terminal was launched from

$auto_backup = false
#If set to true, everytime you close a game the launcher starts the backup process


$start_command = ""
#Optional custom command that is executed everytime you launch a game

$close_command = ""
#Optional custom command that is executed after you close the game

$display_horizontal = true
#When displaying game options, show them horizontally or vertically, change to false to display vertically

$ascii_art ="          ''''''''''          ''''''''''
      ''''##########''      ''##########''''
      ''##############''  ''##############''
    ''##################''##################''
    ''############--####''####--############''
    ############------##''##------############
    ''##########------##''##------##########''
    ''##################''##################''
    ''################''çç''################''
    ''''############''çççççç''############''''
  ''çççç''''''''''''çççççççççç''''''''''''çççç''
  ''çççççççççççççççççççççççççççççççççççççççççç''
''çççççççççççççççççççççççççççççççççççççççççççççç''
''çççççççççççççççççççççççççççççççççççççç0000çççç''
''çç00000000çççççççççççççççççççççççççç00000000çç''
''çç00000000çççççççççççççççççççççççççç00000000çç''
''çç00000000çççççççççççççççççççççççççç000000çççç''
  ''çççççççççççççççççççççççççççççççççççççççççç''
  ''''çççççççç''''çççççççççççççç''''çççççççç''''
    ''''çççççççççç''''çççççççç''''çççççççç''''
        ''''çççççççç''''çç''''çççççççç''''
            ''''''''''''''''''''''''''"
#The ASCII art that shows up when you start Kerolauncher. Change to $ascii_art = "" to disable
