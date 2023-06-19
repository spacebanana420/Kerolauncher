def arg_base ()
    args = ARGV
    if args.length == 0
        return false
    end
    case args[0]
    when "help"
        arg_help(); return true
    when "play"
        ARGV.clear
        if args.length >= 2 then arg_play(args[1]) else arg_play("") end
        return true
    when "cmd"
        ARGV.clear
        play_command(); return true
    when "files"
        ARGV.clear
        filebrowser(); return true
    end
    ARGV.clear
    return false
end

def arg_help ()
    puts "----KEROLAUNCHER HELP MENU----

Launching Kerolauncher without a correct or any argument will launch the user interface
Alternatively, you can use the following options to use the argument-based cli

        ----Avaliable options:----

        - help - Opens this menu

        - play [mode] - Opens the menu of one of the available play modes
            Avaliable modes: native  wine  lutris  steamrun  appimagerun  emulator
            The available modes can vary between different operative systems

        - cmd - Opens the menu for the available configured commands

        - files - Opens the file explorer

        ----Menu Operations----

        --Play--
            Description: Launch your programs natively on your system

        --Launch command--
            Descriptions: Launches one of your commands, brings many possibilities to the table

        --Play (wine)--
            Description: Launch Windows exclusive programs with WINE, for Linux, BSD and MacOS users

        --Play (lutris)--
            Description: Launch games that you have configured on Lutris. For Linux only

        --Play (emulated)--
            Description: Launches a preconfigured emulator with the path to a ROM file as argument to directly launch the games

        --Play (steam-run) and Play (appimage-run)--
            Description: 2 options which are exclusive to NixOS, to make it easy to run standalone binaries and appimages without hassle

        --Backup data--
            Copies the data from the paths you chose on config.rb to the destination path of your choice.

        --Export/restore config--
            Allows you to export your config.rb or import one into a new fresh copy of Kerolauncher
    "
end

def arg_play(inmode) #Limit choice for different systems
    avaliable_modes = ["native", "emulator"]
    if $platform == 1
        avaliable_modes.push("wine")
    end
    if $uname.include?("linux") == true || $uname.include?("Linux") == true
        avaliable_modes.push("lutris")
    end
    if $uname.include?("nixos") == true
        avaliable_modes.push("steamrun"); avaliable_modes.push("appimagerun")
    end

    if inmode == ""
        puts "You need to choose a play mode!"
        puts "Available modes: #{avaliable_modes}"
        return
    end

    isavailable = false
    for mode in avaliable_modes
        if inmode == mode
            isavailable = true
            break
        end
    end

    if isavailable == false
        puts "The play mode you chose (#{inmode}) doesn't exist or is not avaliable for your system!"
        puts "Available modes: #{avaliable_modes}"
        return
    end

    case inmode
    when "native"
        play_game(false)
    when "wine"
        play_game(true)
    when "lutris"
        play_lutris()
    when "steamrun"
        play_game_nixos(false)
    when "appimagerun"
        play_game_nixos(true)
    when "emulator"
        play_emulator()
    end
end
