require 'fileutils'

date_now = Time.now.strftime("%m-%d-%Y")
p date_now

FileUtils::mkdir_p "mixes/#{date_now}"
