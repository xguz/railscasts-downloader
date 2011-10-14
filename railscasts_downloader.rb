#!/usr/bin/ruby
require 'rss'

p 'Downloading rss index'

rss_string = open('http://feeds.feedburner.com/railscasts').read
rss = RSS::Parser.parse(rss_string, false)
videos_urls = rss.items.map { |it| it.enclosure.url }.reverse

videos_filenames = videos_urls.map {|url| url.split('/').last }
existing_filenames = Dir.glob('*.mp4')
missing_filenames = videos_filenames - existing_filenames
p "Downloading #{missing_filenames.size} missing videos"

missing_videos_urls = videos_urls.select { |video_url| missing_filenames.any? { |filename| video_url.match filename } }



missing_videos_urls.each do |video_url|
  filename = video_url.split('/').last
  p filename
  p %x(wget -c #{video_url} -O #{filename}.tmp )
  p %x(mv #{filename}.tmp #{filename} )
end
p 'Finished synchronization'
