#This is the entire configuration of the program. Manual setup is required from here.
#All text settings need to be between quotation marks, and multiple text strings (inside []) need to be separated by commas
#Example: $games = ["Touhou 16", "A Hat in Time", "Blender", "Super Mario 64"]
#Each entry can be separated between lines, as long as they are inside the brackets and a comma separates them

#The use of Lutris is only available to operative systems supported by the program, such as Linux
#Non-Windows systems require Wine to be installed in order to launch Windows executables

$games = []
#Add the names for your native programs here

$game_paths = []
#The path(s) to the games' executables, same order as above
#The programs in this list need to be native to your operative system


$wine_games = []
#Add the names for your programs that you want to execute with Wine

$wine_game_paths = []
#Add the paths for the said programs above


$lutris_games = []
#Add the names for Lutris entries here to be displayed

$lutris_games_id = []
#The Lutris entry ID for the same programs above at the same order


$emulated_games = []
#Add the name of your console games

$emulated_game_paths = []
#The path to the roms of the respective games above
#File extension determines the console!
#Supported formats:
    #.nds
    #.cia, .cci, .3ds
    #.wbfs
    #.gba
    #.sfc

#The commands for launching console games through the cli
#Example: "melonds" or "/path/to/melonds" "flatpak run net.kuribo64.melonDS"
#You can change this command to change the emulator or add arguments
#If left empty, the commands will default to what they originally were
$nds_command = "melonds" #DS and DSi
$threeds_command = "citra" #3DS and 2DS
$wii_command = "dolphin-emu" #Wii
$gba_command = "mgba" #GBA
$snes_command = "snes9x" #SNES



$backup_paths = []
#The path to the folders or files that you want to back up

$backup_destination = ""
#The path to where the backed up folders and files go
#If it's empty or non-existant, it will default to the path where the terminal was launched from

$auto_backup = false
#If set to true, everytime you close a game the launcher starts the backup process

#$compressed_format = ".tohoss"

$start_command = ""
#Optional custom command that is executed everytime you launch a game

$close_command = ""
#Optional custom command that is executed after you close the game

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
