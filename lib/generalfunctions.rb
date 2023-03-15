# def deflate_file(filename) #Compress file with deflate
#     newfilename = filename + $compressed_format
#     if filename.include?(".bmp") == true && filename.include?($compressed_format) == false
#         input_file = File::read(filename)
#         output_file = Zlib::Deflate.deflate(input_file, 5)
#         File::write(newfilename, output_file)
#         File::rename(newfilename, "screenshots_backup/#{newfilename}")
#         return newfilename
#     elsif filename.include?(".png") == true
#         File::rename(filename, "screenshots_backup/#{filename}")
#         return filename
#     end
# end
#
# def inflate_file(filename) #Decompress file with deflate
#     if filename.include?($compressed_format) == true
#         filename_noext = filename.sub!($compressed_format, "")
#         input_file = File::read(filename)
#         output_file = Zlib::Inflate.inflate(input_file)
#         File::write(filename_noext, output_file)
#     end
# end

def read_answer(options, printstring, errormessage, numrange) #Print options in 1 string and read user input
    puts options
    puts printstring
    answer = gets.chomp
    if numrange.include?(answer) == false
        puts errormessage
        return false
    end
    answer = answer.to_i
    return answer
end

def read_answer_array(options_array, printstring, errormessage, numrange) #Print options as an array and read user input
    for option in options_array
        print "#{option}     "
    end
    puts ""; puts printstring
    answer = gets.chomp
    if numrange.include?(answer) == false
        puts errormessage
        return false
    end
    answer = answer.to_i
    return answer
end

def read_answer_iterate(options_array, printstring, errormessage) #Print options as an array ordered by number and read user input
    iteration=0
    for option in options_array
        print "#{iteration}: #{option}     "
        iteration+=1
    end
    iteration-=1
    puts ""; puts printstring
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
    return answer
end

def execute_silent(command)
    if $platform == 0
        return system("#{command} >> NUL")
    else
        return system("#{command} >> /dev/null")
    end
end