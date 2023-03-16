require "zlib"
require "./config/config.rb"
require "./lib/generalfunctions.rb"
require "./lib/backup.rb"

# if $compressed_format == ""
#     puts "Configuration error! Compressed file extension is empty!"
#     return
# elsif $compressed_format.include?(".") == false
#     $compressed_format = "." + $compressed_format
# end

# Quick config error checks for safety
error_output = Array.new

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

    if $emulated_games.length != $emulated_game_paths.length
        error_output.push("Configuration error! Emulated game names and paths are misconfigured!")
    end

    for i in $emulated_game_paths
        if File::file?(i) == false
            error_output.push("Configuration error! Check if your emulated game paths lead to a file")
            break
        end
    end

    if $nds_command == ""
        $nds_command = "melonds"
    end
    if $threeds_command == ""
        $threeds_command = "citra"
    end
    if $wii_command == ""
        $wii_command = "dolphin-emu"
    end
    if $gba_command == ""
        $gba_command = "mgba"
    end
    if $snes_command == ""
        $snes_command = "snes9x"
    end
end


wine_thread = Thread::new do
    if $lutris_games.length != $lutris_games_id.length
        error_output.push("Configuration error! Lutris games or Lutris game IDs are misconfigured!")
    end

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

games_thread.join; wine_thread.join; backup_thread.join

if error_output.length != 0
    for error in error_output
        puts error; puts ""
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
            puts "You did not add any Wine game entries yet! Open config.rb to setup the configuration"
            return
        end
    else
        if $games.length == 0
            puts "You did not add any game entries yet! Open config.rb to setup the configuration"
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
        puts "You did not add any game entries yet! Open config.rb to setup the configuration"
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
        puts "You did not add any Lutris entries yet! Open config.rb to setup the configuration"
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

def play_emulator()
    if $emulated_games.length == 0
        puts "You did not add any console game entries yet! Open config.rb to setup the configuration"
        return
    end
    gamechoice = read_answer_iterate($emulated_games, "Choose a game to play", "You need to choose one of the available games!")
    if gamechoice == false
        return
    end
    if $start_command != ""
        system($start_command)
    end

    puts "Launching #{$emulated_games[gamechoice]}..."
    if $emulated_game_paths[gamechoice].include?(".nds") == true
        system("#{$nds_command} '#{$emulated_game_paths[gamechoice]}'")

    elsif $emulated_game_paths[gamechoice].include?(".cia") == true || $emulated_game_paths[gamechoice].include?(".cci") == true || $emulated_game_paths[gamechoice].include?(".3ds") == true
        system("#{$threeds_command} '#{$emulated_game_paths[gamechoice]}'")

    elsif $emulated_game_paths[gamechoice].include?(".wbfs") == true
        system("#{$wii_command} '#{$emulated_game_paths[gamechoice]}'")

    elsif $emulated_game_paths[gamechoice].include?(".gba") == true
        system("#{$gba_command} '#{$emulated_game_paths[gamechoice]}'")

    elsif $emulated_game_paths[gamechoice].include?(".sfc") == true
        system("#{$snes_command} '#{$emulated_game_paths[gamechoice]}'")

    else
        puts "Error! ROM type is unknown!"
        puts "Check the ROM's file extension"
        return
    end
    if $close_command != ""
        system($close_command)
    end
end


if $ascii_art != ""
    puts $ascii_art
end
title = "////////////////////////////
//Kerolauncher version 1.0//
////////////////////////////"
puts "";
puts title; puts ""

while true
    if $platform == 0 #For Windows
        options = ["0. Exit", "1. Play", "2. Play (emulated)", "3. Backup data"]
        answer = read_answer_array(options, "Choose an operation", "You need to choose a correct operation!", "0123")
        if answer == false
            return
        end
        case answer
        when 0
            return
        when 1
            play_game(false)
        when 2
            play_emulator()
        when 3
            backup_base()
        end
        if answer >= 1 && answer < 3 && $auto_backup == true
            backup_base()
        end
    elsif $uname.include?("nixos") == true #For specifically NixOS
        options = ["0. Exit", "1. Play", "2. Play (Wine)", "3. Play (steam-run)", "4. Play (appimage-run)", "5. Play (Lutris)" "6. Play (emulated)", "7. Backup data"]
        answer = read_answer_array(options, "Choose an operation", "You need to choose a correct operation!", "01234567")
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
            play_emulator()
        when 7
            backup_base()
        end
        if answer >= 1 && answer < 7 && $auto_backup == true
            backup_base()
        end
    else # For every other operative system
        options = ["0. Exit", "1. Play", "2. Play (Wine)", "3. Play (Lutris)", "4. Play (emulated)", "5. Backup data"]
        answer = read_answer_array(options, "Choose an operation", "You need to choose a correct operation!", "012345")
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
            play_emulator()
        when 5
            backup_base()
        end
        if answer >= 1 && answer < 5 && $auto_backup == true
            backup_base()
        end
    end
    puts ""
end
