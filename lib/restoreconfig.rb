def restore_config_base ()
    config_options = ["$games", "$game_paths", "$wine_games", "$wine_game_paths", "$lutris_games", "$lutris_games_id", "$lutris_command", "$command_names", "$command_programs", "$emulated_games", "$emulated_game_paths", "$nds_command", "$threeds_command", "$wii_command", "$gba_command", "$snes_command", "$custom_emu_command", "$backup_paths", "$backup_destination", "$auto_backup", "$start_command", "$close_command", "$display_horizontal"]

    options = ["0. Exit", "1. Export config", "2. Restore config"]
    answer = read_answer_array(options, "Choose an operation", "You need to choose a correct operation!", "012")
    case answer
    when 0
        return
    when 1
        export_config(config_options)
    when 2
        import_config(config_options)
    end
end

def export_config (options)
    backup_file = ""
    config_file = File::readlines("config/config.rb")
    for line in config_file
        if find_config_in_line(line, options) == true && line.include?("#") == false
            backup_file += "#{line}\n"
        end
    end
    File::write("config_backup.export", backup_file)
    puts "config.rb has been backed up!"
end

def find_config_in_line(line, options)
    for option in options
        if line.include?(option) == true
            return true
        end
    end
    return false
end

def replace_config_in_line(line, backup_file, options)
    for backline in backup_file
        for option in options
            if line.include?(option) == true && backline.include?(option) == true && line.include?("#") == false && backline.include?("#") == false
                return backline
            end
        end
    end
    return false
end

def check_for_export ()
    paths = Dir::children
    for path in paths
        if path.include?(".export") == true
            return path
        end
    end
    return false
end

def import_config (options)
    puts "Write here the path to the config backup or leave a config.rb or .export file in the root of Kerolauncher"
    config_path = gets.chomp
    export_find = check_for_export()
    if File::file?(config_path) == true
        backup_file = File::readlines(config_path)
    elsif File::file?("config.rb") == true
        puts "Found a config.rb in the root location, using this file"
        backup_file = File::readlines("config.rb")
    elsif export_find != false
        backup_file = File::readlines(export_find)
    else
        puts "You didn't specify a correct path and a config.rb or.export file hasn't been found in root"; return
    end

    puts "Your config's settings will be changed, continue? (y/n)"
    answer = gets.chomp
    if answer != "y" && answer != "yes"
        puts "Cancelling..."
        return
    end

    old_config = File::readlines("config/config.rb")

    for i in 0..old_config.length-1
        newsetting = replace_config_in_line(old_config[i], backup_file, options)
        if newsetting != false
            old_config[i] = newsetting
        end
    end
    finalconfig = ""
    for line in old_config #Required or else bug
        finalconfig += line
    end
    File::write("config/config.rb", finalconfig)
end
