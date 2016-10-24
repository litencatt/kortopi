require 'fileutils'

def file_renamer path
  i = 1
  Dir.glob("./#{path}/*") do |filename|
    ext = File.extname(filename)
    num = sprintf("%03d", i)
    newname = "./#{path}/g#{num}#{ext}"
    puts filename
    puts newname
    FileUtils.mv(filename, newname)
    i += 1
  end
end

file_renamer ARGV[0]
