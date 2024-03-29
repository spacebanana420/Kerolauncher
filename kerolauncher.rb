require "./config/config.rb"
require "./lib/tui.rb"
require "./lib/generalfunctions.rb"
require "./lib/backup.rb"
require "./lib/errorchecks.rb"
require "./lib/restoreconfig.rb"
require "./lib/cliargs.rb"
require "./lib/filebrowser.rb"
require "./lib/readtemplates.rb"

# Checks for errors to avoid launching the program unsafely
if errorcheck_config() == false || errorcheck() == false
    return
end

$starting_path = Dir.pwd()

if "ABCDEFGHIJKLMNOPQRSTUVWXYZ".include?($starting_path.chars[0]) == true && $starting_path.chars[1] == ":"
    $platform = 0 #Windows
elsif File::exist?("/etc/nixos/configuration.nix") == true
    $platform = 1 #NixOS
else
    uname = `uname -a`
    if uname.include?("linux") == true || uname.include?("Linux") == true
        $platform = 2 #Linux
    else
        $platform = 3 #MacOS, BSD, Haiku, etc
    end

end

def play_game(gameList, gamePaths, mode) #Play games, and with or without wine
    if gameList.length == 0
        if mode == "wine"
            presstocontinue("You did not add any Wine game entries yet! Open config.rb to setup the configuration")
        elsif mode == "lutris"
            presstocontinue("You did not add any Lutris entries yet! Open config.rb to setup the configuration\nTo find out what ID your entries use, type \"lutris -l\" in the terminal")
        else
            presstocontinue("You did not add any game entries yet! Open config.rb to setup the configuration")
        end
        return
    end
    gamechoice = read_answer_iterate(gameList, "Choose a game to play", "You need to choose one of the available games!")

    if gamechoice == false
        return
    end
    if $start_command != ""
        system($start_command)
    end

    puts "Launching #{gameList[gamechoice]}..."
    case mode
    when "wine"
        system("wine", gamePaths[gamechoice])
    when "native"
        system([gamePaths[gamechoice]])
    when "lutris"
        system($lutris_command, gamePaths[gamechoice])
    when "nixos-appimage"
        system("appimage-run", gamePaths[gamechoice])
    when "nixos-steamrun"
        system("steam-run", gamePaths[gamechoice])
    end

    if $close_command != ""
        system($close_command)
    end
end

def play_emulator() #Launch emulators from the CLI with ROMs as their arguments
    if $emulated_games.length == 0
        presstocontinue("You did not add any console game entries yet! Open config.rb to setup the configuration")
        return
    end
    extensions = [".nds", ".cia", ".3ds", ".wbfs", ".gba", ".sfc"]
    commands = [$nds_command, $threeds_command, $threeds_command, $wii_command, $gba_command, $snes_command]
    finalcommand = ""

    gamechoice = read_answer_iterate($emulated_games, "Choose a game to play", "You need to choose one of the available games!")
    if gamechoice == false
        return
    end

    i = 0
    extensions.each do |fmt|
        if $emulated_game_paths[gamechoice].inclue?(fmt) == true
            finalcommand = commands[i]
            break
        end
        i += 1
    end

    if $start_command != ""
        system($start_command)
    end

    puts "Launching #{$emulated_games[gamechoice]}..."
    if finalcommand != ""
        system(finalcommand, $emulated_game_paths[gamechoice])
    elsif $custom_emu_command != ""
        system($custom_emu_command, $emulated_game_paths[gamechoice])
    else
        presstocontinue("Error! ROM type is unknown!\nTo launch unknown ROM files, you need to set up $custom_emu_command in config.rb")
        return
    end

    if $close_command != ""
        system($close_command)
    end
end


def play_command() #Play games, and with or without wine
    if $command_programs.length == 0
        presstocontinue("You did not add any command entries yet! Open config.rb to setup the configuration")
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

def play_menu()
    clearterminal()
    title = "///Play Menu///\n"
    case $platform
    when 0
        options = ["0. Exit", "1. Play", "2. Play (emulated)"]
        operations = [0, 1, 4]
        answer = spawntui(title, options, "Choose an operation", "You need to choose a correct operation!", "012")
    when 1
        options = ["0. Exit", "1. Play (native)", "2. Play (Wine)", "3. Play (steam-run)", "4. Play (appimage-run)", "5. Play (Lutris)", "6. Play (emulated)"]
        answer = spawntui(title, options, "Choose an operation", "You need to choose a correct operation!", "0123456")
        operations = [0, 1, 2, 5, 6, 3, 4]
    when 2
        options = ["0. Exit", "1. Play (native)", "2. Play (Wine)", "3. Play (Lutris)", "4. Play (emulated)"]
        answer = spawntui(title, options, "Choose an operation", "You need to choose a correct operation!", "01234")
        operations = [0, 1, 2, 3, 4]
    when 3
        options = ["0. Exit", "1. Play (native)", "2. Play (Wine)", "3. Play (emulated)"]
        answer = spawntui(title, options, "Choose an operation", "You need to choose a correct operation!", "0123")
        operations = [0, 1, 2, 4]
    end
    if answer == nil
        return
    end

    case operations[answer]
    when 1
        play_game($games, $game_paths, "native")
    when 2
        play_game($wine_games, $wine_game_paths, "wine")
    when 3
        play_game($lutris_games, $lutris_game_id, "lutris")
        #play_lutris()
    when 4
        play_emulator()
    when 5
        play_game($games, $game_paths, "nixos-appimage")
        #play_game_nixos(false)
    when 6
        play_game($games, $game_paths, "nixos-steamrun")
        #play_game_nixos(true)
    end
end

if arg_base() == true then return end


title = ""
if $ascii_art != ""
    title += $ascii_art + "\n\n"
end
title += "////////////////////////////
//Kerolauncher version 1.6//
////////////////////////////\n"

while true
    clearterminal()
    options = ["0. Exit", "1. Play", "2. Launch command", "3. File browser", "4. Backup data", "5. Export/restore config"]
    answer = spawntui(title, options, "Choose an operation", "You need to choose a correct operation!", "012345")

    if answer == false || answer == 0
        return
    end
    case answer
    when 1
        play_menu()
    when 2
        play_command()
    when 3
        filebrowser()
    when 4
        backup_base()
    when 5
        if restore_config_base() == true
            return
        end
    end
    if $auto_backup == true && answer < 4
        backup_base()
    end
    puts ""
end
