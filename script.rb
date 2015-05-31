require 'fileutils'

tracks = [
  "https://soundcloud.com/sensualmusique/eklo-lets-go-home-fanfar-remix",
  "https://soundcloud.com/axmod/major-lazer-dj-snake-lean-on-axmod-remix",
  "https://soundcloud.com/tocadisco/koen-groeneveld-100-tocadisco-remix",
  "http://hypem.com/track/28jd8/Favela+-+Gong",
  "https://www.youtube.com/watch?v=nuHfVn_cfHU"
]
date_now = Time.now.strftime("%m-%d-%Y")
mix_directory = "mixes/#{date_now}"
absolute_mix_directory =  Dir.pwd + "/" + mix_directory
intro_url = "http://f.cl.ly/items/1e1P0z240a2a3n2d003w/intro.wav"
crossfade_duration = 7
intro_location = absolute_mix_directory + "/mix.wav"

FileUtils::mkdir_p mix_directory

tracks.each do |track|
  system "youtube-dl #{track} -x --audio-format wav -o '#{absolute_mix_directory}/tracks/%(id)s.%(ext)s'"
  p track
end

mix_tracks = Dir["#{absolute_mix_directory}/tracks/*.wav"]

system "wget -O #{intro_location} #{intro_url}"

mix_tracks.each do |track|
  p track
  system "sh crossfade_cat.sh #{crossfade_duration} #{intro_location} #{track} auto auto #{intro_location}"
  p track + " has been faddded"
end

system "rm -rf #{absolute_mix_directory}/tracks"
system "ffmpeg -i #{intro_location} -codec:a libmp3lame -qscale:a 2 #{absolute_mix_directory}/final-mix.mp3"
system "rm -rf #{intro_location}"
