require 'open-uri'
require 'nokogiri'
require 'mechanize'
require 'cgi'


# https://soundcloud.com/bromancerecords/kaytranada-spring-mixtape-for
tracklist = "Deborah Cox - It's Over Now (Annie Starlight Remix)
Mike Gao - Playin Too Much
Acid Washed - Fire And Rain (Kaytranada Edition)
Jonas LR - Cockiness
Chris Malinchak - At Night
Lone - Ultramarine
A Tribe Called Quest - Go Ahead In The Rain
Paul Johnson - Get Get Down
JMSN - Love & Pain (Kaytranada Edition)
Madlib - Disco Break (looped)
DJ Rels - The Doo
Patrice Rushen - Forget Me Nots
Cybertron - Clear
Honom - Purple Sun
Teedra Moses - Be Your Girl (Kaytranada Edition)
Cherokee & Kartell - Atwater
Diana Ross - My Old Piano
Disclosure x MNEK - White Noise (Full Crate & FS Green Remix Instrumental)
Zo! - Nights Over Egypt (featuring Carlitta Durrand)
Swv - Give It To Me"
formatted = tracklist.lines.map(&:chomp)

formatted.each do |track|
  p track.strip

  url = "https://duckduckgo.com/html/?q=#{CGI.escape(track + ' site:soundcloud.com')}"
  mech_agent = Mechanize.new { |agent| agent.user_agent_alias = "Mac Safari" }
  html = mech_agent.get(url).body
  doc = Nokogiri::HTML(html, 'UTF-8')
  # doc = Nokogiri::HTML(open(url), 'UTF-8')
  result = doc.at_css('.large')
  p result[:href]
  sleep(10)
end
