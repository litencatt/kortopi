require 'find'
require 'fileutils'
require 'phashion'

def file_finder(path)
  arr = Array.new
  Find.find(path) do |f|
    next unless FileTest.file?(f)
    ext = File.extname(f)
    case ext
    when ".png", ".gif", ".jpg", ".jpeg"
      arr << f
    end
  end
  arr
end

inpt = ARGV[0]
path = ARGV[1]

min = [100, ""]

img1 = Phashion::Image.new(inpt)

arrInput = file_finder(path)
arrInput.each do |img|
  img2 = Phashion::Image.new(img)
  puts img
  tmp = img1.distance_from(img2)
  if tmp < min[0]
    min = [tmp, img]
  end
end

puts "#{inpt} #{min[1]}"
