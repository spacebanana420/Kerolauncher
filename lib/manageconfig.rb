def profile_base()
    if File::dir?("../config") == false
        puts "Error! The config folder is missing!"
        return false
    elsif File::dir?("../config/profiles") == false
        Dir::mkdir("../config/profiles")
    end
    Dir::chdir("../config/profiles")
end


def create_profile()
    profilestring = "VERSION 1.1\n\n"
    profile_name = answer_profile("Choose a name for this profile", false)

    if $uname.include?("nixos") == true
        proftypes = ["game", "command", "command_alone", "wine", "lutris", "steam-run", "appimage-run"]
    elsif $platform != 0
        proftypes = ["game", "command", "command_alone", "wine", "lutris"]
    else
        proftypes = ["game", "command", "command_alone"]
    end
    profile_type = answer_profile_array("Choose a profile type", proftypes)

    entry_name = answer_profile("Add a name for this entry", true)
    entry_path = answer_profile("Add a path for this entry", true)

    start_command = answer_profile("Add a startup command (leave blank to disable)", false)
    close_command = answer_profile("Add a close command (leave blank to disable)", false)

    settings = [profile_name, profile_type. entry_name, entry_path]
    if start_command != ""
        settings.push(start_command)
    end
    if close_command != ""
        settings.push(close_command)
    end
    for setting in settings
        profilestring = profilestring + setting + "\n"
    end
    profile = File::new("#{profile_name}.profile")
    File::write(profile, profilestring)
end

def read_profile()

end

def answer_profile_array(question, options)
    answer = answer_profile(question)
    isoptionhere = false
    while true
        for option in options
            if answer == option
                break
                isoptionhere = true
            end
        end
    end
    if isoptionhere == false
        puts "You need to choose one of the available options!"
    else
        return answer
    end
end

def answer_profile(question, issemicolonevil)
    while true
        puts question
        answer = gets.chomp
        if answer.include?(";") == true && issemicolonevil == true
            puts "Your answer cannot have a semicolon!"
        elsif answer == ""
            puts "Your answer is empty!"
        else
            break
        end
    end
    return answer
end

def read_config_line(setting)
    for char in setting.chars
    end
end
