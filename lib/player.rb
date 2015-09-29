require 'scraperwiki'

class Player
  def initialize(nation, row)
    @nation = nation
    @row = row
  end

  def save!
    ScraperWiki.save_sqlite(["name", "nation"], {"name" => name, "link" => link, "nation" => @nation})
  end

  def name
    @row.css(".vcard a").first.text
  end

  def link
    "https://en.wikipedia.org" + @row.css(".vcard a").first['href']
  end
end
