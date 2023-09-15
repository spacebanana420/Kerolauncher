def getTemplates()
    tui = "---Templates---\n\n0: Exit\n"
    files = Dir.children("#{$starting_path}/config/")
    templates = Array.new()
    files.each do |file|
        if file != "config.rb"
            templates.push(file)
        end
    end
    if templates.length == 0
        puts "You don't have any templates in your \"config\" directory!"
        return
    end
    i = 1
    templates.each do |file|
        tui += "#{i}: #{file}\n"
        i += 1
    end
    tui += "\nChoose a template"
    puts tui
    choice = gets.chomp
    if choice == "0" || belongsToRange(choice, templates.length) == false
        return
    end
    choice = choice.to_i
    openTemplate(templates[choice-1])
end


def openTemplate(template)
    name, command, paths = readTemplate(template)
    i = 1
    tui = "---#{name}---\n\n0: Exit\n"
    paths.each do |path|
        tui += "#{i}: #{path}\n"
        i += 1
    end
    tui += "\nChoose a path"
    puts tui
    choice = gets.chomp
    if choice == "0" || getNumRange(paths.length).include?(choice) == false
        return
    end
    chocie = choice.to_i
    puts "Executing #{paths[choice-1]}..."
    system(command, paths[choice-1])
end

def readTemplate(template)
    # if File.file?("#{$starting_path}/config/templates.txt") == false
    #     return
    # end
    name = ""
    command = Array.new()
    paths = Array.new()
    templateLines = File.readlines(template)

    templateLines.each do |line|
        if line.include?("name=") == true && line.chars[0] != "#"
            name = parseCommand(line)
        elsif line.include?("command=") == true && line.chars[0] != "#"
           command = parseCommand(line)
        elsif line.include?(":") == true  && line.chars[0] != "#"
            paths.push(parsePath(line))
        end
    end
    return name, command, paths
end

def parseCommand(line)
    cmdArgs = Array.new()
    lineChars = line.chars()
    startCopying = false
    arg = ""

    lineChars.each do |char|
        if char == " " && arg != ""
            cmdArgs.push(arg)
            arg = ""
        elsif startCopying == true
            arg += char
        elsif char == "="
            startCopying = true
        end
    end
    return cmdArgs
end


def parsePath(line)
    cmdArgs = Array.new()
    lineChars = line.chars()
    #copy_state = 0
    arg = ""

    lineChars.each do |char|
        if char == ":" && arg != ""
            cmdArgs.push(arg)
            arg = ""
        else
            arg += char
        end
    end

    cmdArgs.push(arg)
    if cmdArgs[0] == "" || cmdArgs[1] == ""
        cmdArgs.push("error")
    end
    return cmdArgs
end
