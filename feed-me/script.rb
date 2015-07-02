require 'dotenv'
require 'soundcloud'
require 'awesome_print'
require 'time_diff'
Dotenv.load

client = SoundCloud.new({
  :client_id     => ENV['CLIENT_ID'],
  :client_secret => ENV['CLIENT_SECRET'],
  :username      => ENV['SOUNDCLOUD_USERNAME'],
  :password      => ENV['SOUNDCLOUD_PASSWORD']
})

# See the track information returned back
# client.get('/me/activities').collection.each do |track|
#   ap track.origin
# end

# Hacker News Sorting http://amix.dk/blog/post/19574
#
# (Favorites) / (Time ago in hours +2 )^1.8
client.get('/me/activities').collection.each do |track|
  favorites =  track.origin['favoritings_count']
  time_ago_in_hours = Time.diff(Time.now, Time.parse(track.created_at))[:hour]
  score = (favorites / ((time_ago_in_hours + 2)**1.8)).ceil
  p "#{track.origin['title']} - #{score}"
end

