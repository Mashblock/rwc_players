# This is a template for a Ruby scraper on morph.io (https://morph.io)
# including some code snippets below that you should find helpful

require 'scraperwiki'
require 'nokogiri'
require 'open-uri'
# require 'mechanize'
#
# agent = Mechanize.new
#
# # Read in a page
# page = agent.get("http://foo.com")
#
# # Find somehing on the page using css selectors
# p page.at('div.content')
#
# # Write out to the sqlite database using scraperwiki library
# ScraperWiki.save_sqlite(["name"], {"name" => "susan", "occupation" => "software developer"})
#
# # An arbitrary query against the database
# ScraperWiki.select("* from data where 'name'='peter'")

# You don't have to do things with the Mechanize or ScraperWiki libraries.
# You can use whatever gems you want: https://morph.io/documentation/ruby
# All that matters is that your final data is written to an SQLite database
# called "data.sqlite" in the current working directory which has at least a table
# called "data".

nations = ["Australia", "England", "Fiji", "Uruguay", "Wales", "Japan", "Samoa",
  "Scotland", "South Africa", "United States", "Argentina", "Georgia",
  "Namibia", "New Zealand", "Tonga", "Canada", "France", "Ireland", "Italy",
  "Romania"]

doc = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/2015_Rugby_World_Cup_squads"))

nations.each do |nation|
  table = doc.xpath("//*[@id='#{nation.gsub(/\s/, "_")}']/../following-sibling::table[1]")
  rows = table.css("table.wikitable tr.agent")
  rows.each do |row|
    name = row.css(".vcard a").first.text
    link = "https://en.wikipedia.org" + row.css(".vcard a").first['href']
    ScraperWiki.save_sqlite(["name", "nation"], {"name" => name, "link" => link, "nation" => nation})
  end
end
