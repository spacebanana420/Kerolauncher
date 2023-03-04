require "zlib"
#///////////////////////////////////
#///////////Configuration///////////
#///////////////////////////////////
#This is the entire configuration of the program. Manual setup is required from here.
#All text settings need to be between quotation marks, and multiple text strings (inside []) need to be separated by commas
#Example: $games = ["Touhou 16", "A Hat in Time", "Blender", "Super Mario 64"]
#Each entry can be separated between lines, as long as they are inside the brackets and a comma separates them

#The use of Lutris is only available to operative systems supported by the application, such as Linux
#Non-Windows systems require Wine to be installed in order to launch Windows executables

$games = ["Yuzu"]
#Add the names for your programs here, like lutris_games
$game_paths = ["/home/space/Applications/yuzu.AppImage"]
#The path(s) to the games' executables, same order as above

$wine_games = []
#Add the names for your programs that you want to execute with Wine
$wine_game_paths = []
#Add the paths for the said programs above

$lutris_games = ["Touhou 7", "Touhou 10", "Touhou 11", "Touhou 15", "Touhou 16", "Touhou 18"]
#Add the names for Lutris entries here to be displayed
$lutris_games_id = [13, 21, 22, 4, 36, 1]
#The Lutris entry ID for the same programs above at the same order

$backup_paths = ["/home/space/Imagens/froge.png"]
#The path to the folders or files that you want to back up

$backup_destination = ""
#The path to where the backed up folders and files go
#If it's empty or non-existant, it will default to the path where the terminal was launched from

$auto_backup = false
#If set to true, everytime you close a game the launcher starts the backup process

$screenshot_compressed_format = ".tohoss"
#The file extension for compressed screenshots, make sure it's a unique extension

$global_command = ""
#Optional custom command that is executed everytime you launch a game

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
#//////////////////////////////////////////
#///////////End of configuration///////////
#//////////////////////////////////////////

# Quick config error checks for safety
if $screenshot_compressed_format == ""
    puts "Configuration error! Compressed file extension is empty!"
    return
elsif $screenshot_compressed_format.include?(".") == false
    $screenshot_compressed_format = "." + $screenshot_compressed_format
end

if $lutris_games.length != $lutris_games_id.length
    puts "Configuration error! Lutris games or Lutris game IDs are misconfigured!"
    return
end

if $games.length != $game_paths.length
    puts "Configuration error! game names and locations are misconfigured!"
    return
end

for i in $game_paths
    if File::file?(i) == false
        puts "Configuration error! Check if your game paths lead to a file"
        return
    end
end

for i in $backup_paths
    if File::exist?(i) == false
        puts "Configuration error! Check if your backup paths are correct."
        return
    end
end

for i in 0..$backup_paths.length - 1
    if i != 0 && $backup_paths[i] == $backup_paths[i-1]
        puts "Configuration error! There are 2 or more repeated save paths!"
        puts "Make sure each path is different for the save directories"
        return
    end
end

$starting_path = Dir::pwd

def deflate_file(filename) #Compress file with deflate
    newfilename = filename + $screenshot_compressed_format
    if filename.include?(".bmp") == true && filename.include?($screenshot_compressed_format) == false
        input_file = File::read(filename)
        output_file = Zlib::Deflate.deflate(input_file, 5)
        File::write(newfilename, output_file)
        File::rename(newfilename, "screenshots_backup/#{newfilename}")
        return newfilename
    elsif filename.include?(".png") == true
        File::rename(filename, "screenshots_backup/#{filename}")
        return filename
    end
end

def inflate_file(filename) #Decompress file with deflate
    if filename.include?($screenshot_compressed_format) == true
        filename_noext = filename.sub!($screenshot_compressed_format, "")
        input_file = File::read(filename)
        output_file = Zlib::Inflate.inflate(input_file)
        File::write(filename_noext, output_file)
    end
end

def read_answer(options, printstring, errormessage, numrange) #Print options in 1 string and read user input
    puts options
    puts printstring
    answer = gets.chomp
    if numrange.include?(answer) == false
        puts errormessage
        return false
    end
    answer = answer.to_i
    return answer
end

def read_answer_array(options_array, printstring, errormessage, numrange) #Print options as an array and read user input
    for option in options_array
        print "#{option}     "
    end
    puts ""; puts printstring
    answer = gets.chomp
    if numrange.include?(answer) == false
        puts errormessage
        return false
    end
    answer = answer.to_i
    return answer
end

def read_answer_iterate(options_array, printstring, errormessage) #Print options as an array ordered by number and read user input
    iteration=0
    for option in options_array
        print "#{iteration}: #{option}     "
        iteration+=1
    end
    iteration-=1
    puts ""; puts printstring
    answer = gets.chomp
    numrange = ""
    for digit in 0..iteration
        numrange += digit.to_s
    end
    if numrange.include?(answer) == false
        puts errormessage
        return false
    end
    answer = answer.to_i
    return answer
end

def play_game(usewine) #Play games, and with or without wine
    if $games.length == 0
        puts "You did not add any game entries yet! Open Kerolauncher's file to setup the configuration"
        puts "Add the path to the executable to the list, alongside the game's number"
        return
    end
    if usewine == true
        gamechoice = read_answer_iterate($wine_games, "Choose a game to play", "You need to choose one of the available games!")
    else
        gamechoice = read_answer_iterate($games, "Choose a game to play", "You need to choose one of the available games!")
    end
    if gamechoice == false
        return
    end
    if $global_command != ""
        system($global_command)
    end
    puts "Launching #{$games[gamechoice]}..."
    if usewine == true
        system("wine '#{$game_paths[gamechoice]}'")
    else
        system("'#{$game_paths[gamechoice]}'")
    end
end

def play_lutris() #Play games with Lutris, only for supported systems
    if $lutris_games.length == 0
        puts "You did not add any Lutris entries yet! Open Kerolauncher's file to setup the configuration"
        puts "To find out what ID your entries use, type 'lutris -l' in the terminal"
        return
    end
    gamechoice = read_answer_iterate($lutris_games, "Choose a game to play", "You need to choose one of the available games!")
    if gamechoice == false
        return
    end
    if $global_command != ""
        system($global_command)
    end
    puts "Launching #{$lutris_games[gamechoice]} (Lutris)..."
    system("lutris rungameid/#{$lutris_games_id[gamechoice]}")
    return
end

def backup_base()
    if $backup_destination == "" || File::exist?($backup_destination) == false || File::file?($backup_destination) == true
        $backup_destination = $starting_path
    end
    if $backup_paths.length == 0
        puts "You did not add any backup paths yet! Open the program file to setup the configuration"
        puts "You can add the path to a file or folder"
        return
    end
    #operation = read_answer("0. Backup screenshots     1. Backup save", "Choose an operation", "Choose a correct operation!", "01")
    for path in $backup_paths
        pathfile = get_filename_from_path(path)
        if File::file?(path) == true
            backupfile = File::read(path)
            File::write("#{$backup_destination}/#{pathfile}", backupfile)
        else
            backup_dir(path, $backup_destination)
            Dir::chdir($starting_path)
        end
        #copy to destination
    end
end

def backup_dir(backuppath, destination)
    dirname = get_filename_from_path(backuppath)
    Dir::chdir(backuppath)
    Dir::mkdir("#{destination}/#{dirname}")
    for path in backuppath
        pathname = get_filename_from_path(path)
        if File::file?(path) == true
            backupfile = File::read(path)
            File::write("#{destination}/#{pathname}", backupfile)
        else
            backup_dir(path,"#{destination}/#{pathname}")
            Dir::chdir("..")
        end
    end
end

def get_filename_from_path(path)
    filename = ""
    path_characters = path.chars.reverse
    filename_characters = Array::new
    for char in 0..path_characters.length-1
        if path_characters[char] == "/" || path_characters[char] == "'\'"
            break
        end
        filename_characters.push(path_characters[char])
    end
    filename_characters = filename_characters.reverse
    for char in 0..filename_characters.length-1
        filename += filename_characters[char]
    end
    puts filename
    return filename
end

if $ascii_art != ""
    puts $ascii_art
end
while true
    title = "////////////////////////////
//Kerolauncher version 0.1//
////////////////////////////"
    puts ""; #puts "Kerolauncher version 0.1";
    puts title; puts ""
    options = ["0. Exit", "1. Play", "2. Play (Wine)", "3. Play (Lutris)", "4. Backup data"]
    answer = read_answer_array(options, "Choose an operation", "You need to choose a correct operation!", "01234")
    if answer == false
        return
    end
    case answer
    when 0
        return
    when 1
        play_game(false)
    when 2
        play_game(true)
    when 3
        play_lutris()
    when 4
        backup_base()
    end

    if answer >= 1 && answer < 4 && $auto_backup == true
        backup_base()
    end
    puts ""
end
