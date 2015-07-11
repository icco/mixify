require 'dotenv'
require 'soundcloud'
require 'awesome_print'
Dotenv.load

def get_ranked
  client = SoundCloud.new({
    :client_id     => ENV['CLIENT_ID'],
    :client_secret => ENV['CLIENT_SECRET'],
    :username      => ENV['SOUNDCLOUD_USERNAME'],
    :password      => ENV['SOUNDCLOUD_PASSWORD']
  })

  ranked = Hash.new
  href = '/me/activities?limit=200'
  while href and href != ""
    resp = client.get(href)
    resp.collection.each do |track|
      if track.type == "track"
        favorites =  track.origin['favoritings_count']
        title = track.origin['permalink_url']
        time_ago_in_hours = (Time.now - Time.parse(track.origin.created_at)) / (60 * 60)
        score = favorites / (time_ago_in_hours + 2)
        if time_ago_in_hours > 8 * 24
          return ranked
        elsif time_ago_in_hours > 24
          ranked[title] = score
        end
      end
    end
    href = resp.next_href
  end
end

ap get_ranked.sort_by {|title, score| score }.reverse.to_h
