def clearterminal()
    if $platform == 0
        system("cls")
    else
        system("clear")
    end
end

def spawntui(title, options, printstring, errormessage, numrange)
    printtext=title + "\n"
    for option in options
        if $display_horizontal == true
            printtext += "#{option}     "
        else
            printtext += "\n#{option}"
        end
    end
    printtext += "\n\n#{printstring}"
    puts printtext
    answer = gets.chomp
    if numrange.include?(answer) == false || answer == ""
        puts errormessage
        presstocontinue()
        return nil
    end
    answer = answer.to_i
    return answer
end

def presstocontinue(msg)
    puts msg + "\n\nPress enter to continue"
    gets
end

def read_answer_array(options_array, printstring, errormessage, numrange) #Print options as an array and read user input
    printtext=""
    for option in options_array
        if $display_horizontal == true
            printtext += "#{option}     "
        else
            printtext += "\n#{option}"
        end
    end
    puts "#{printtext}\n#{printstring}"
    answer = gets.chomp
    if numrange.include?(answer) == false
        puts errormessage
        return false
    end
    answer = answer.to_i
    return answer
end

def read_answer(options, printstring, errormessage, numrange) #Print options in 1 string and read user input
    puts "#{options}\n#{printstring}"
    answer = gets.chomp
    if numrange.include?(answer) == false
        puts errormessage
        return false
    end
    answer = answer.to_i
    return answer
end

def read_answer_loop(printstring)
    while true
        puts printstring
        answer = gets.chomp
        if answer != ""
            break
        end
        puts "Your answer cannot be empty!"
    end
    return answer
end

def read_answer_iterate(options_array, printstring, errormessage) #Print options as an array ordered by number and read user input
    iteration=0
    printtext=""
    if $display_horizontal == true
        printtext += "#{iteration}: Exit     "
    else
        printtext += "\n#{iteration}: Exit"
    end
    for option in options_array
        iteration+=1
        if $display_horizontal == true
            printtext += "\n#{iteration}: #{option}     "
        else
            printtext += "\n#{iteration}: #{option}"
        end
    end
    puts "#{printtext}\n#{printstring}"
    answer = gets.chomp
    numrange = ""
    for digit in 0..iteration
        numrange += digit.to_s
    end
    if numrange.include?(answer) == false
        puts errormessage
        return false
    end
    answer = answer.to_i
    if answer == 0 then return false end
    answer -= 1
    return answer
end
