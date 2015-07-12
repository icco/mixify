#! /usr/bin/env ruby

require 'bundler/setup'
Bundler.require

Dotenv.load

def get_ranked
  client = SoundCloud.new({
    :client_id     => ENV['CLIENT_ID'],
    :client_secret => ENV['CLIENT_SECRET'],
    :username      => ENV['SOUNDCLOUD_USERNAME'],
    :password      => ENV['SOUNDCLOUD_PASSWORD']
  })

  days = Hash.new

  href = '/me/activities?limit=200'
  while href and href != ""
    # Get user's last 200 tracks
    resp = client.get(href)

    resp.collection.each do |track|
      if track.type == "track"
        favorites = track.origin['favoritings_count']
        plays = track.origin['playback_count']
        title = track.origin['permalink_url']
        time_ago_in_hours = (Time.now - Time.parse(track.origin.created_at)) / (60 * 60)

        # Turn into a float of minutes
        duration = track.origin['duration'] / 60 / 1000
        score = (favorites.to_f / plays.to_f) * 100

        if duration > 12 or score < 2
          next
        end

        if time_ago_in_hours > 8 * 24
          # Sort each day by score.
          days.each do |day, scores|
            days[day] = scores.sort_by {|title, score| score }.reverse.to_h
          end

          return days
        elsif time_ago_in_hours > 24
          date = Time.parse(track.origin.created_at).strftime("%F")
          if days[date].nil?
            days[date] = {}
          end

          days[date][title] = score
        end
      end
    end

    # We've looked at 200 tracks, and none are older than 8 days, so we should
    # keep going through the history.
    href = resp.next_href
  end
end

# ap get_ranked.sort_by {|title, score| score }.reverse.to_h
ap get_ranked
