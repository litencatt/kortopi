require 'find'
require 'fileutils'
require 'phashion'

def file_finder(path)
  arr = Array.new
  Find.find(path) do |f|
    next unless FileTest.file?(f)
    ext = File.extname(f)
    case ext
    when ".png", ".jpg", ".jpeg"
      arr << f
    end
  end
  arr
end

def pattern path
  f = 16
  tmp = '/tmp/imgmatch.xbm'
  `convert -level 0%,75%,0.8 -fuzz 50% -trim -resize #{f}x#{f}! #{path} #{tmp}`
  ptn = File.open(tmp).read.scan(/0x[\dA-F]{2}/).map{|n| n.hex.to_s(2).rjust(8, '0')}.join.split(//)
  File.delete tmp
  return ptn
end

def get_avehash_score file1,file2
  a1 = pattern file1
  a2 = pattern file2
  a1.zip(a2).count{|n, m| n == m}.to_f / a1.size.to_f
end


i_path = ARGV[0]
c_path = ARGV[1]
i_arr = []
if FileTest.directory?(i_path)
  i_arr = file_finder(i_path)
elsif
  i_arr << i_path
end
c_arr = file_finder(c_path)

p_output = []
a_output = []
i_arr.each do |i|
  p_tmp = 0.0
  a_tmp = 0.0
  p_result = ""
  a_result = ""

  a1 = pattern i
  c_arr.each do |c|
    a2 = pattern c
    aHash_score = a1.zip(a2).count{|n, m| n == m}.to_f / a1.size.to_f
    if aHash_score > a_tmp
      a_tmp = aHash_score
      a_result = "#{i} #{c} #{a_tmp}"
    end
  end
  a_output << a_result
end
puts "Average Hash:"
puts a_output
