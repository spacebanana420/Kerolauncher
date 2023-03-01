require "zlib"

#/////Configuration/////

$lutris_games = [7, 10, 11, 15, 16, 18]
#Add your Touhou Lutris entries here (example: 7 or 07 for Touhou 7/07)
$lutris_games_id = [13, 21, 22, 4, 36, 1]
#The Lutris game ID for the Touhou games, order corresponds with the order of the games list above

$touhou_games = []
#Add your Touhou games here (example: 7 or 07 for Touhou 7/07)
$touhou_game_locations = []
#The path(s) to the games' executables, order corresponds to the order of the games list above
$touhou_save_locations = ["/home/space/.wine/drive_c/users/space/AppData/Roaming/ShanghaiAlice"]
#The path to Touhou data folders that you want to backup, either ShanghaiAlice for modern games or the path to the older games

$screenshot_compressed_format = ".tohoss"
#The file extension for compressed screenshots, make sure it's a unique extension

$global_command = ""
#Custom command that is executed everytime you launch a game

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
#/////End of configuration/////

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

if $touhou_games.length != $touhou_game_locations.length
    puts "Configuration error! Touhou games and locations are misconfigured!"
    return
end

for i in $touhou_game_locations
    if Dir::exist?(i) == false
        puts "Configuration error! Check if your Touhou game paths are correct."
        return
    end
end

for i in $touhou_save_locations
    if Dir::exist?(i) == false
        puts "Configuration error! Check if your Touhou save paths are correct."
        return
    end
end

for i in 0..$touhou_save_locations.length - 1
    if $touhou_save_locations[i] != 0 && $touhou_save_locations[i] != $touhou_save_locations[i-1]
        puts "Configuration error! There are 2 or more repeated save paths!"
        puts "Make sure each path is different for the save directories"
        return
    end
end

$starting_path = Dir::pwd

def deflate_file(filename)
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

def inflate_file(filename)
    if filename.include?($screenshot_compressed_format) == true
        filename_noext = filename.sub!($screenshot_compressed_format, "")
        input_file = File::read(filename)
        output_file = Zlib::Inflate.inflate(input_file)
        File::write(filename_noext, output_file)
    end
end

def read_answer(options, printstr, numrange)
    puts options
    puts printstr
    answer = gets.chomp
    if numrange.include?(answer) == false
        return false
    end
    answer = answer.to_i
    return answer
end

def read_answer_array(options, printstr, numrange)
    for option in options
        print "#{option}     "
    end
    puts ""; puts printstr
    answer = gets.chomp
    if numrange.include?(answer) == false
        return false
    end
    answer = answer.to_i
    return answer
end

def general_play(wine)
    # if $lutris_games.length == 0
    #     puts "You did not add any Touhou entries yet! Open the program file to setup the configuration"
    #     return
    # end
    # iter = 0
    # for path in $touhou_game_locations
    #     if File::executable?(path) == true
    #         game_check(path, true)
    #     elsif File::dir?(path) == true
    #         game_check(path, false)
    #     end
    #     #print "#{iter}: Touhou #{game}     "
    #     #iter+=1
    #         #add to array first
    # end
    if $touhou_games.length == 0
        puts "You did not add any Touhou entries yet! Open the program file to setup the configuration"
        puts "Add the path to the executable to the list, alongside the game's number"
        return
    end
    iter = 0
    for game in $touhou_games
        print "#{iter}: Touhou #{game}     "
        iter+=1
    end
    puts ""
    iter = $touhou_games.length - 1
    puts "Choose a game to play"
    gamechoice = gets.chomp
    digits = ""
    for digit in 0..$touhou_games.length - 1
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
        puts "Launching Touhou #{gamechoice}..."
        if wine == true
            system("wine '#{$touhou_game_locations[gamechoice]}'")
        else
            system("'./#{$touhou_game_locations[gamechoice]}'")
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

def lutris_play()
    if $lutris_games.length == 0
        puts "You did not add any Touhou Lutris entries yet! Open the program file to setup the configuration"
        puts "To find out what ID your entries use, type 'lutris -l' in the terminal"
        return
    end
    iter = 0
    for game in $lutris_games
        print "#{iter}: Touhou #{game}     "
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
            puts "Launching Touhou #{gamechoice} (Lutris)..."
            system("lutris rungameid/#{$lutris_games_id[gamechoice]}")
        else
            puts "You need to choose one of the available games!"
            return
        end
end

def backup_base()
    if $touhou_save_locations.length == 0
        puts "You did not add any Touhou data paths yet! Open the program file to setup the configuration"
        puts "In modern Touhou games, they are located in ShanghaiAlice, inside AppData"
        puts "In older Touhou games, the scorefile, screenshots and replays, are instead directly located in the game's folder"
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
    for location in $touhou_save_locations
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
