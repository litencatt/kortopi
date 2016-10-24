require 'nokogiri'
require 'open-uri'

uri = "https://timg.azurewebsites.net/55_kumamon#"

charset = nil
html = open(uri) do |f|
  charset = f.charset
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)

tmp = doc.xpath('//figure')
tmp.each do |img|
  p img.xpath('//img')
end

