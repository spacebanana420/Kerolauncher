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

def execute_silent(command)
    if $platform == 0
        return system("#{command} >> NUL")
    else
        return system("#{command} >> /dev/null")
    end
end

def get_file_extension(filename)
    extension = ""
    addchar = false
    for char in filename.chars
        if char == "." && addchar == false
            addchar == true
        elsif char == "." && addchar == true
            extenion = ""
        end
        if addchar == true
            extension += char
        end
    end
    return extenion
end
