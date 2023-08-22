def filebrowser()
    while true
        clearterminal()
        paths, paths_num = print_dirs()
        answer = gets.chomp; answernum = answer.to_i
        count=0
        if answernum == 0 then return
        elsif answernum == 1 then Dir::chdir("..")
        else
            for path in paths
                if answernum == paths_num[count]
                    open_path(path); break
                end
                count+=1
            end
        end
    end
end

def open_path(path)
    if File::file?(path) == true
        if File::executable?(path) == true then system("./" + path); return end
        if $platform == 0
            system("explorer.exe \"#{path}\"")
        else
            system("xdg-open \"#{path}\"")
        end
    else
        Dir::chdir(path)
    end
end

def print_dirs()
    finalstring = "0: Exit     1: Go back\n---Directories---\n"
    paths = Dir::children(".")
    dirs = Array.new(); files = Array.new()
    allpaths = Array.new(); allpaths_num = Array.new()

    for path in paths
        if File::file?(path) == true
            files.push(path)
        else
            dirs.push(path)
        end
    end
    count=2
    pathsprinted=0
    for dir in dirs
        if pathsprinted == 3 then pathsprinted = 0; finalstring += "\n" end
        finalstring += "#{count}: #{dir}     "

        allpaths.push(dir); allpaths_num.push(count)
        count+=1; pathsprinted+=1
    end
    pathsprintedi=0
    finalstring += "\n---Files---\n"
    for file in files
        if pathsprinted == 3 then pathsprinted = 0; finalstring += "\n" end
        finalstring += "#{count}: #{file}     "

        allpaths.push(file); allpaths_num.push(count)
        count+=1; pathsprinted+=1
    end
    finalstring += "\n"

    puts finalstring
    return allpaths, allpaths_num
end
