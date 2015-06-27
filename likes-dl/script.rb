require "rubygems"
require "dotenv"
require "json"
require "open-uri"
require "pry"
require "soundcloud"

Dotenv.load

# Helpers
def download_cmd(url)
  "youtube-dl --add-metadata -o '/Users/#{ENV['SYSTEM_USER']}/Downloads/_music/%(title)s.%(ext)s' #{url}"
end

# Soundcloud
client = SoundCloud.new(:client_id => ENV['SOUNDCLOUD_CLIENT_ID'])
tracks = client.get("/users/#{ENV['SOUNDCLOUD_USER']}/favorites")
tracks.each do |track|
  url = track.permalink_url
  system download_cmd(url)
end

# Hypemachine
# response = Net::HTTP.get_response("hypem.com", "/playlist/loved/#{ENV['HYPEM_USER']}/json/1/data.js")
# tracks = JSON.parse(response.body)
# tracks.values.each do |track|
#   next unless track.is_a? Hash
#   url = "http://hypem.com/track/#{track['mediaid']}/"
#   system download_cmd(url)
# end

# Clean up thumbnails
# system "find /Users/#{ENV['SYSTEM_USER']}/Downloads/_music/ -type f -name '*thumb-resize*' -delete"
