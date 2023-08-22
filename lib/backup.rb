def backup_base()
    if $backup_destination == "" || File::exist?($backup_destination) == false || File::file?($backup_destination) == true
        $backup_destination = $starting_path
    end
    if $backup_paths.length == 0
        presstocontinue("You did not add any backup paths yet! Open the program file to setup the configuration\nYou can add the path to a file or folder")
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
