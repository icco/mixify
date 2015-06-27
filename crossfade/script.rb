require 'fileutils'

setlist = ARGV[0]
mix_name = setlist.sub("https://soundcloud.com/","").gsub!("/","-").sub("-sets","")
date_now = Time.now.strftime("%m-%d-%Y")
mix_directory = "mixes/#{date_now}-#{mix_name}"
absolute_mix_directory =  Dir.pwd + "/" + mix_directory
intro_url = "http://f.cl.ly/items/1e1P0z240a2a3n2d003w/intro.wav"
crossfade_duration = 7
intro_location = absolute_mix_directory + "/mix.wav"

FileUtils::mkdir_p mix_directory

system "youtube-dl #{setlist} -x --audio-format wav -o '#{absolute_mix_directory}/tracks/%(id)s.%(ext)s'"

mix_tracks = Dir["#{absolute_mix_directory}/tracks/*.wav"]

system "wget -O #{intro_location} #{intro_url}"

mix_tracks.each do |track|
  system "sh crossfade_cat.sh #{crossfade_duration} #{intro_location} #{track} auto auto #{intro_location}"
end

system "rm -rf #{absolute_mix_directory}/tracks"
system "ffmpeg -i #{intro_location} -codec:a libmp3lame -qscale:a 2 #{absolute_mix_directory}/final-mix.mp3"
system "rm -rf #{intro_location}"
