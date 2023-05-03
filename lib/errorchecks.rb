def errorcheck_config()
    error_output = Array.new

    config_options = ["$games", "$game_paths", "$wine_games", "$wine_game_paths", "$lutris_games", "$lutris_game_id", "$lutris_command", "$command_names", "$command_programs", "$emulated_games", "$emulated_game_paths", "$nds_command", "$threeds_command", "$wii_command", "$gba_command", "$snes_command", "$custom_emu_command", "$backup_paths", "$backup_destination", "$auto_backup", "$start_command", "$close_command", "$display_horizontal", "$ascii_art"]

    config_file = File::read("config/config.rb")
    config_file_nocomments = ""
    copychar = true
    for char in config_file.chars
        if char == "#"
            copychar = false
        elsif char == "\n"
            copychar = true
        end

        if copychar == true
            config_file_nocomments += char
        end
    end

    firsterror = true
    for option in config_options
        if config_file_nocomments.include?(option) == false
            if firsterror == true
                firsterror = false
                puts "Kerolauncher has closed!\nConfig.rb has missing settings! In particular: "
            end
            error_output.push("#{option} ")
        end
    end

    if error_output.length != 0
        for error in error_output
            print error
        end
        return false
    end
end

def errorcheck()
    error_output = Array.new

    if $display_horizontal != false && $display_horizontal != true
        $display_horizontal = true
    end

    games_thread = Thread::new do
        if $games.length != $game_paths.length
            error_output.push("Configuration error! The number of game paths and their names is not the same!")
        end
        for i in $game_paths
            if File::file?(i) == false
                error_output.push("Configuration error! Check if your game paths lead to a file and not a directory")
                break
            end
        end

        if $emulated_games.length != $emulated_game_paths.length
            error_output.push("Configuration error! The number of game ROMs and their names is not the same!")
        end

        for i in $emulated_game_paths
            if File::file?(i) == false
                error_output.push("Configuration error! Check if your emulated game paths lead to a file and not a directory")
                break
            end
        end

        if $command_names.length != $command_programs.length
            error_output.push("Configuration error! The number of commands and their display names is not the same!")
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
        if $lutris_games.length != $lutris_game_id.length
            error_output.push("Configuration error! The number of Lutris IDs and their names is not the same!")
        end

        if $lutris_command == ""
            $lutris_command = "lutris rungameid/"
        end

        if $wine_games.length != $wine_game_paths.length
            error_output.push("Configuration error! The number of wine game paths and their names is not the same!")
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
        puts ""
        return false
    end
end
