require 'fileutils'
require 'highline/import'
require 'open-uri'
require 'rmagick'

include Magick

BASE_URI = 'http://droughtmonitor.unl.edu/data/pngs'

def filename(d)
  "imgs/#{d.strftime('%Y%m%d')}_west_date.png"
end

def url(d)
  "#{BASE_URI}/#{d.strftime('%Y%m%d')}/#{d.strftime('%Y%m%d')}_west_date.png"
end

_date = ask('Enter a start date (MM/DD/YYYY): ').split('/')
date = Date.new(_date[2].to_i, _date[0].to_i, _date[1].to_i)

weeks = ask('Enter number of weeks to scrape images for: ').to_i

FileUtils.rm_rf('imgs/') if File.exists?('imgs/')
Dir.mkdir('imgs')

(0..weeks).each do
  begin
    File.open(filename(date), 'wb') { |f| f.write(open(url(date)).read) }
  rescue OpenURI::HTTPError
    File.delete(filename(date))
  end

  date = date - 7
end

gif = ImageList.new(*Dir['imgs/*.png'].sort)
gif.delay = 80
gif.write('drought.gif')

