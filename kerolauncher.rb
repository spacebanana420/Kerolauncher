require "zlib"

#///////////Configuration///////////
#This is the entire configuration of the program. Manual setup is required from here.
#All text settings need to be between quotation marks, and multiple text strings (inside []) need to be separated by commas
#Example: $games = ["Touhou 16", "A Hat in Time", "Blender", "Super Mario 64"]
#Each entry can be separated between lines, as long as they are inside the brackets and a comma separates them

#The use of Lutris is only available to operative systems supported by the application, such as Linux
#Non-Windows systems require Wine to be installed in order to launch Windows executables

$lutris_games = ["Touhou 7", "Touhou 10", "Touhou 11", "Touhou 15", "Touhou 16", "Touhou 18"]
#Add the names for Lutris entries here to be displayed
$lutris_games_id = [13, 21, 22, 4, 36, 1]
#The Lutris entry ID for the same programs above at the same order

$games = ["Yuzu"]
#Add the names for your programs here, like lutris_games
$game_paths = ["/home/space/Applications/yuzu.AppImage"]

$wine_games = []
#Add the names for your programs that you want to execute with Wine
$wine_game_paths = []
#Add the paths for the said programs above

#The path(s) to the games' executables, same order as above
$backup_paths = ["/home/space/.wine/drive_c/users/space/AppData/Roaming/ShanghaiAlice"]
#The path to the folders or files that you want to back up

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
#///////////End of configuration///////////

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
    if $backup_paths[i] != 0 && $backup_paths[i] != $backup_paths[i-1]
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

def read_answer(options, printstring, numrange) #Print options in 1 string and read user input
    puts options
    puts printstring
    answer = gets.chomp
    if numrange.include?(answer) == false
        return false
    end
    answer = answer.to_i
    return answer
end

def read_answer_array(options, printstring, numrange) #Print options as an array and read user input
    for option in options
        print "#{option}     "
    end
    puts ""; puts printstring
    answer = gets.chomp
    if numrange.include?(answer) == false
        return false
    end
    answer = answer.to_i
    return answer
end

def general_play(usewine) #Play games, and with or without wine
    # if $lutris_games.length == 0
    #     puts "You did not add any Touhou entries yet! Open the program file to setup the configuration"
    #     return
    # end
    # iter = 0
    # for path in $game_paths
    #     if File::executable?(path) == true
    #         game_check(path, true)
    #     elsif File::dir?(path) == true
    #         game_check(path, false)
    #     end
    #     #print "#{iter}: Touhou #{game}     "
    #     #iter+=1
    #         #add to array first
    # end
    if $games.length == 0
        puts "You did not add any game entries yet! Open Kerolauncher's file to setup the configuration"
        puts "Add the path to the executable to the list, alongside the game's number"
        return
    end
    iter = 0
    for game in $games
        print "#{iter}:#{game}     "
        iter+=1
    end
    puts ""
    iter = $games.length - 1
    puts "Choose a game to play"
    gamechoice = gets.chomp
    digits = ""
    for digit in 0..$games.length - 1
        digits += digit.to_s
    end
    if digits.include?(gamechoice) == false
        puts "You need to choose one of the available games!"
        return
    end
    gamechoice = gamechoice.to_i
    correctinput = false
    for number in 0..iter
        if gamechoice == number
            correctinput = true
            break
        end
    end
    if correctinput == true
        if $global_command != ""
            system($global_command)
        end
        puts "Launching #{gamechoice}..."
        if usewine == true
            system("wine '#{$game_paths[gamechoice]}'")
        else
            system("'./#{$game_paths[gamechoice]}'")
        end
    else
        puts "You need to choose one of the available games!"
        return
    end
end

# def game_check(path, mode)
#     game_number = ""
#     if mode == true
#     else
#     end
# end

def lutris_play() #Play games with Lutris, only for supported systems
    if $lutris_games.length == 0
        puts "You did not add any Lutris entries yet! Open Kerolauncher's file to setup the configuration"
        puts "To find out what ID your entries use, type 'lutris -l' in the terminal"
        return
    end
    iter = 0
    for game in $lutris_games
        print "#{iter}:#{game}     "
        iter+=1
    end
    puts ""
    iter = $lutris_games.length - 1
    puts "Choose a game to play"
    gamechoice = gets.chomp
    digits = ""
    for digit in 0..$lutris_games.length - 1
        digits += digit.to_s
    end
    if digits.include?(gamechoice) == false
        puts "You need to choose one of the available games!"
        return
    end
    gamechoice = gamechoice.to_i
    correctinput = false
    for number in 0..iter
        if gamechoice == number
            correctinput = true
            break
        end
    end
        if correctinput == true
            if $global_command != ""
                system($global_command)
            end
            puts "Launching #{gamechoice} (Lutris)..."
            system("lutris rungameid/#{$lutris_games_id[gamechoice]}")
        else
            puts "You need to choose one of the available games!"
            return
        end
end

def backup_base()
    if $backup_paths.length == 0
        puts "You did not add any backup paths yet! Open the program file to setup the configuration"
        puts "You can add the path to a file or folder"
        return
    end
    options = ["0. Backup screenshots", "1. Backup save"]
    operation = read_answer_array(options, "Choose an operation", "01")
    if operation == false
        puts "Choose a correct operation!"
        return
    end
    mode = read_answer("0. Compress and backup     1. Restore from backup", "Choose a mode", "01")
    if mode == false
        puts "Choose a correct mode!"
        return
    end
    for location in $backup_paths
        Dir::chdir(location)
        games = Dir::children(".")
        for game in games
            if game.include?("th") == true
                Dir::chdir(game)
                if operation == 0
                    backup_screenshots(mode)
                else
                    backup_save(mode)
                end
                Dir::chdir("..")
            end
        end
        Dir::chdir("..")
    end
    Dir::chdir($starting_path)
end

def backup_screenshots(mode)
    foundfolder = false
    paths = Dir::children(".")
    for path in paths
        if path == "snapshot" && File::directory?(path) == true
            Dir::chdir(path)
            foundfolder = true
            break
        end
    end
    if foundfolder == true
        paths = Dir::children(".")
        if Dir::exist?("screenshots_backup") == false
            Dir::mkdir("screenshots_backup")
        end
        for path in paths
            if mode == 0
                deflate_file(path)
            else
                inflate_file(path)
            end
        end
        #Dir::chdir("..")
    else
        puts "The screenshot folder 'snapshots' has not been found"
        return
    end
end

def backup_save()
    paths = Dir::children(".")
    for path in paths
        if mode == 0
            #optional newfile = deflate_file(filename)
            #make it copy File::rename(newfile, "screenshots_backup/#{newfile}")
        else
            #optional inflate_file(filename)
        end
    end
    Dir::chdir("..")
end

#def lutris_config()
#end

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
    answer = read_answer_array(options, "Choose an operation", "01234")
    if answer == false
        puts "You need to choose a correct operation!"
        return
    end
    case answer
    when 0
        return
    when 1
        general_play(true)
    when 2
        general_play(false)
    when 3
        lutris_play()
    when 4
        backup_base()
    end
    puts ""
end
