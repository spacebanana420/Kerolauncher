#This is the entire configuration of the program. Manual setup is required from here.
#All text settings need to be between quotation marks, and multiple text strings (inside []) need to be separated by commas
#Example: $games = ["Touhou 16", "A Hat in Time", "Blender", "Super Mario 64"]
#Each entry can be separated between lines, as long as they are inside the brackets and a comma separates them

#The use of Lutris is only available to operative systems supported by the application, such as Linux
#Non-Windows systems require Wine to be installed in order to launch Windows executables

$games = []
#Add the names for your programs here, like lutris_games
$game_paths = []
#The path(s) to the games' executables, same order as above

$wine_games = []
#Add the names for your programs that you want to execute with Wine
$wine_game_paths = []
#Add the paths for the said programs above

$lutris_games = []
#Add the names for Lutris entries here to be displayed
$lutris_games_id = []
#The Lutris entry ID for the same programs above at the same order

$backup_paths = []
#The path to the folders or files that you want to back up

$backup_destination = ""
#The path to where the backed up folders and files go
#If it's empty or non-existant, it will default to the path where the terminal was launched from

$auto_backup = false
#If set to true, everytime you close a game the launcher starts the backup process

$compressed_format = ".tohoss"
#The file extension for compressed screenshots, make sure it's a unique extension

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
