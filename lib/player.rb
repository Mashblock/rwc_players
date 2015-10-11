require 'scraperwiki'

class Player
  LOCKED_NATIONS = ["New Zealand", "France", "Ireland", "England"]

  def initialize(nation, row)
    @nation = nation
    @row = row
  end

  def as_json
    { name: name, link: link, nation: @nation, date_of_birth: date_of_birth,
      club: club, caps: caps, club_nation: club_nation }
  end

  def save!
    ScraperWiki.save_sqlite([:name, :nation], as_json)
  end

  def name
    @row.css(".vcard a").first.text
  end

  def link
    "https://en.wikipedia.org" + @row.css(".vcard a").first['href']
  end

  def club_nation
    return @nation if LOCKED_NATIONS.include?(@nation)
    return nil unless @row.css("span.flagicon a").length > 0
    @row.css("span.flagicon a").first['title'].gsub('(country)', '').strip
  end

  def caps
    @row.css("td")[3].text.to_i
  end

  def club
    @row.css("td")[4].text
  end

  def date_of_birth
    return nil unless @row.css("span.bday").length > 0
    Date.parse(@row.css("span.bday").first.text)
  end
end
