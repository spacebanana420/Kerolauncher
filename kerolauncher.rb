require "zlib"
require "./config/config.rb"
require "./lib/generalfunctions.rb"

# if $compressed_format == ""
#     puts "Configuration error! Compressed file extension is empty!"
#     return
# elsif $compressed_format.include?(".") == false
#     $compressed_format = "." + $compressed_format
# end

# Quick config error checks for safety
error_output = Array.new

lutris_thread = Thread::new do
    if $lutris_games.length != $lutris_games_id.length
        error_output += "Configuration error! Lutris games or Lutris game IDs are misconfigured!\n\n"
    end
end

games_thread = Thread::new do
    if $games.length != $game_paths.length
        error_output.push("Configuration error! Game names and paths are misconfigured!")
    end
    for i in $game_paths
        if File::file?(i) == false
            error_output.push("Configuration error! Check if your game paths lead to a file")
            break
        end
    end
end


wine_thread = Thread::new do
    if $wine_games.length != $wine_game_paths.length
        error_output.push("Configuration error! Wine game names and paths are misconfigured!")
    end

    for i in $wine_game_paths
        if File::file?(i) == false
            error_output.push("Configuration error! Check if your Wine game paths lead to a file")
            break
        end
    end
end

backup_thread = Thread::new do
    for i in $backup_paths
        if File::exist?(i) == false
            error_output.push("Configuration error! Check if your backup paths are correct.")
        end
    end

    for i in 0..$backup_paths.length - 1
        if i != 0 && $backup_paths[i] == $backup_paths[i-1]
            error_output.push("Configuration error! There are 2 or more repeated save paths!\nMake sure each path is different for the save directories")
            break
        end
    end
end

lutris_thread.join; games_thread.join; wine_thread.join; backup_thread.join

if error_output.length != 0
    for error in error_output
        puts error
    end
    return
end

$starting_path = Dir::pwd

if "ABCDEFGHIJKLMNOPQRSTUVWXYZ".include?($starting_path.chars[0]) == true && $starting_path.chars[1] == ":"
    $platform = 0 #Windows
    $uname = ""
else
    $platform = 1 #Non Windows: Linux, MacOS, BSD, Solaris, etc
    $uname = `uname -a`
end


def play_game(usewine) #Play games, and with or without wine
    if usewine == true
        if $wine_games.length == 0
            puts "You did not add any Wine game entries yet! Open Kerolauncher's file to setup the configuration"
            puts "Add the path to the executable to the list, alongside the game's number"
            return
        end
    else
        if $games.length == 0
            puts "You did not add any game entries yet! Open Kerolauncher's file to setup the configuration"
            puts "Add the path to the executable to the list, alongside the game's number"
            return
        end
    end

    if usewine == true
        gamechoice = read_answer_iterate($wine_games, "Choose a game to play", "You need to choose one of the available games!")
    else
        gamechoice = read_answer_iterate($games, "Choose a game to play", "You need to choose one of the available games!")
    end
    if gamechoice == false
        return
    end
    if $start_command != ""
        system($start_command)
    end
    puts "Launching #{$games[gamechoice]}..."
    if usewine == true
        system("wine '#{$game_paths[gamechoice]}'")
    else
        system("'#{$game_paths[gamechoice]}'")
    end
    if $close_command != ""
        system($close_command)
    end
end

def play_game_nixos(appimage)
    if $games.length == 0
        puts "You did not add any game entries yet! Open Kerolauncher's file to setup the configuration"
        puts "Add the path to the executable to the list, alongside the game's number"
        return
    end
    gamechoice = read_answer_iterate($games, "Choose a game to play", "You need to choose one of the available games!")
    if gamechoice == false
        return
    end
    if $start_command != ""
        system($start_command)
    end
    puts "Launching #{$games[gamechoice]}..."
    if appimage == true
        system("appimage-run '#{$game_paths[gamechoice]}'")
    else
        system("steam-run '#{$game_paths[gamechoice]}'")
    end
    if $close_command != ""
        system($close_command)
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
    if $start_command != ""
        system($start_command)
    end
    puts "Launching #{$lutris_games[gamechoice]} (Lutris)..."
    system("lutris rungameid/#{$lutris_games_id[gamechoice]}")

    if $close_command != ""
        system($close_command)
    end
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
        puts "Backing up #{pathfile}"
        if File::file?(path) == true
            backupfile = File::read(path)
            File::write("#{$backup_destination}/#{pathfile}", backupfile)
        else
            backup_dir(path, $backup_destination)
            Dir::chdir($starting_path)
        end
    end
end

def backup_dir(backuppath, destination)
    dirname = get_filename_from_path(backuppath)
    Dir::chdir(backuppath)
    if Dir::exist?("#{destination}/#{dirname}") == false
        Dir::mkdir("#{destination}/#{dirname}")
    end
    for path in Dir::children(backuppath)
        pathname = get_filename_from_path(path)
        if File::file?(path) == true
            backupfile = File::read(path)
            File::write("#{destination}/#{dirname}/#{pathname}", backupfile)
        else
            if Dir::exist?("#{destination}/#{dirname}/#{pathname}") == false
                Dir::mkdir("#{destination}/#{dirname}/#{pathname}")
            end
            backup_dir("#{backuppath}/#{path}", "#{destination}/#{dirname}")
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
    return filename
end

if $ascii_art != ""
    puts $ascii_art
end
title = "////////////////////////////
//Kerolauncher version 0.2//
////////////////////////////"
puts ""; #puts "Kerolauncher version 0.2";
puts title; puts ""

while true
    if $platform == 0 #For Windows
        options = ["0. Exit", "1. Play", "2. Backup data"]
        answer = read_answer_array(options, "Choose an operation", "You need to choose a correct operation!", "012")
        if answer == false
            return
        end
        case answer
        when 0
            return
        when 1
            play_game(false)
        when 2
            backup_base()
        end
        if answer == 1 && $auto_backup == true
            backup_base()
        end
    elsif $uname.include?("nixos") == true
        options = ["0. Exit", "1. Play", "2. Play (Wine)", "3. Play (steam-run)", "4. Play (appimage-run)", "5. Play (Lutris)", "6. Backup data"]
        answer = read_answer_array(options, "Choose an operation", "You need to choose a correct operation!", "0123456")
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
            play_game_nixos(false)
        when 4
            play_game_nixos(true)
        when 5
            play_lutris()
        when 6
            backup_base()
        end
        if answer >= 1 && answer < 6 && $auto_backup == true
            backup_base()
        end
    else # For every other operative system
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
    end
    puts ""
end
