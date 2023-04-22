require "zlib"
require "./config/config.rb"
require "./lib/generalfunctions.rb"
require "./lib/backup.rb"
require "./lib/errorchecks.rb"


# Checks for errors to avoid launching the program unsafely
if errorcheck_config() == false
    return
elsif errorcheck() == false
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

def play_game_nixos(appimage) #Exclusive options for NixOS, to use steam-run and appimage-run
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

def play_emulator() #Launch emulators from the CLI with ROMs as their arguments
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

    elsif $custom_emu_command != ""
        system("#{$custom_emu_command} '#{$emulated_game_paths[gamechoice]}'")
    else
        puts "Error! ROM type is unknown!"
        puts "To launch unknown ROM files, you need to set up $custom_emu_command in config.rb"
        return
    end
    if $close_command != ""
        system($close_command)
    end
end


def play_command() #Play games, and with or without wine
    if $command_programs.length == 0
        puts "You did not add any game entries yet! Open config.rb to setup the configuration"
        return
    end

    gamechoice = read_answer_iterate($command_names, "Choose a command", "You need to choose one of the available commands!")
    if gamechoice == false
        return
    end
    if $start_command != ""
        system($start_command)
    end
    puts "Launching #{$command_names[gamechoice]}..."
    system("#{$command_programs[gamechoice]}")
    if $close_command != ""
        system($close_command)
    end
end

# def quick_launch()
#     paths = Dir::children(".")
#     files = Array::new
#     iter = 1
#     for path in paths
#         if File::file?(path) == true
#             puts "#{iter}: #{path}"
#             files.push(path)
#             iter += 1
#         end
#     end
#     file_choice = read_answer("", "Choose a file to launch" "", "1")
# end


if $ascii_art != ""
    puts $ascii_art
end
title = "////////////////////////////
//Kerolauncher version 1.2//
////////////////////////////"
puts "";
puts title; puts ""

# def print_options(options, startplay, endplay) #test first!
#     option_numbers = ""
#     for i in 0..options.length-1
#         option_numbers += i.to_s
#     end
#     answer = read_answer_array(options, "Choose an operation", "You need to choose a correct operation!", option_numbers)
#     if answer == false
#         return
#     end
# end

def play_menu()
    if $platform == 0 #For Windows
        options = ["0. Exit", "1. Play", "2. Play (emulated)"]
        operations = [0, 1, 4]
        answer = read_answer_array(options, "Choose an operation", "You need to choose a correct operation!", "012")

    elsif $uname.include?("nixos") == true #For specifically NixOS
        options = ["0. Exit", "1. Play (native)", "2. Play (Wine)", "3. Play (steam-run)", "4. Play (appimage-run)", "5. Play (Lutris)", "6. Play (emulated)"]
        answer = read_answer_array(options, "Choose an operation", "You need to choose a correct operation!", "0123456")
        operations = [0, 1, 2, 5, 6, 3, 4]

    elsif $uname.include?("linux") == true || $uname.include?("Linux") == true #For Linux that isn't NixOS
        options = ["0. Exit", "1. Play (native)", "2. Play (Wine)", "3. Play (Lutris)", "4. Play (emulated)"]
        answer = read_answer_array(options, "Choose an operation", "You need to choose a correct operation!", "01234")
        operations = [0, 1, 2, 3, 4]

    else #For every other operative system
        options = ["0. Exit", "1. Play (native)", "2. Play (Wine)", "3. Play (emulated)"]
        answer = read_answer_array(options, "Choose an operation", "You need to choose a correct operation!", "0123")
        operations = [0, 1, 2, 4]
   end

    case operations[answer]
    when 1
        play_game(false)
    when 2
        play_game(true)
    when 3
        play_lutris()
    when 4
        play_emulator()
    when 5
        play_game_nixos(false)
    when 6
        play_game_nixos(true)
    end
end

while true
    options = ["0. Exit", "1. Play", "2. Launch command", "3. Backup data"]
    answer = read_answer_array(options, "Choose an operation", "You need to choose a correct operation!", "0123")

    if answer == false || answer == 0
        return
    end
    case answer
    when 1
        play_menu()
    when 2
        play_command()
    when 3
        backup_base()
    end
    if $auto_backup == true && answer != 3
        backup_base()
    end
    # if operations[answer] != 8
    #     play_menu()
    #     if $auto_backup == true
    #         backup_base()
    #     end
    # else
    #     backup_base()
    # end
    # if answer >= min && answer < max && $auto_backup == true
    #     backup_base()
    # end
    puts ""
end
