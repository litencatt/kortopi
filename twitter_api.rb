require 'twitter'
require 'open-uri'
require 'fileutils'

@client = Twitter::REST::Client.new do |config|
  config.consumer_key         = ENV['CONSUMER_KEY']
  config.consumer_secret      = ENV['CONSUMER_SECRET']
  config.access_token         = ENV['ACCESS_TOKEN']
  config.access_token_secret  = ENV['ACCESS_TOKEN_SECRET']
end

acount = "55_kumamon"
max_id = @client.user_timeline(acount).first.id
FileUtils.mkdir_p("./twitter-images/#{acount}") unless FileTest.exist?("./twitter-images/#{acount}")
@client.user_timeline(acount, max_id: max_id, count: 200).each_with_index do |t, index|
  unless t.media.empty?
    if index != 0
      t.media.map{|m| m.media_url.to_s}.each do |img_url|
        puts "#{acount} image #{img_url} save to ./twitter-images/#{acount}"
        tmp_path = "./twitter-images/#{acount}/#{File.basename(img_url)}"
        File.open(tmp_path, 'w') do |f|
          f.write open(img_url).read
        end
      end
    end
  end
  max_id = t.id
end
