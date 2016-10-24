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

def get_score file1,file2
  def pattern path
    f = 16
    tmp = '/tmp/imgmatch.xbm'
    `convert -level 0%,75%,0.8 -fuzz 50% -trim -resize #{f}x#{f}! #{path} #{tmp}`
    ptn = File.open(tmp).read.scan(/0x[\dA-F]{2}/).map{|n| n.hex.to_s(2).rjust(8, '0')}.join.split(//)
    File.delete tmp
    return ptn
  end
  a1 = pattern file1
  a2 = pattern file2
  a1.zip(a2).count{|n, m| n == m}.to_f / a1.size.to_f
end

inpt = ARGV[0]
path = ARGV[1]

#arrOutput = Array.new
min = [100, ""]

img1 = Phashion::Image.new(inpt)

arrInput = file_finder(path)
arrInput.each do |img|
  #score = get_score(inpt, img).to_s
  #puts "file:#{img} score:#{score}"
  #arrOutput << [score, img]
  img2 = Phashion::Image.new(img)
  tmp = img1.distance_from(img2)
  if tmp < min[0]
    min = [tmp, img]
  end
end
#arrOutput.sort!
#puts arrOutput[-1][1]
puts "#{inpt} #{min[1]}"
