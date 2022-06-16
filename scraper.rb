require 'fileutils'
require 'optparse'
require_relative './lib/shop_scraper'

def scrape_shops_from_file(filename)
  File.read(filename).split("\n").each do |shop|
    name = shop.strip.gsub(/\/\z/, '').split('/').last
    scrape_shop_to_json(name)
  end
end

def scrape_shop_to_json(shop_name)
  p "Scraping #{shop_name} ..."
  scraped_data = ShopScraper.new(shop_name).scrape
  FileUtils.mkdir_p('scraped_data')
  filename = "scraped_data/#{shop_name}.json"
  p "Writing to #{filename}..."
  File.write(filename, scraped_data.to_json)
end

OptionParser.new do |opt|
  opt.on('-s SHOPNAME') { |s| scrape_shop_to_json(s) }
  opt.on('-f FILENAME') { |f| scrape_shops_from_file(f) }
end.parse!

p 'Done'
