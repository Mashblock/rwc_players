require 'scraperwiki'

class Player
  def initialize(nation, row)
    @nation = nation
    @row = row
  end

  def as_json
    { name: name, nation: @nation, date_of_birth: date_of_birth,
      club: club, caps: caps, club_nation: club_nation }
  end

  def save!
    ScraperWiki.save_sqlite([:name, :nation], as_json)
  end

  def name
    @row.css("td")[0].text.strip
  end

  # def link
  #   "https://en.wikipedia.org" + @row.css(".vcard a").first['href']
  # end

  def club_nation
    return @nation unless @row.css("span.flagicon a").length > 0
    @row.css("span.flagicon a").first['title'].gsub('(country)', '').strip
  end

  def caps
    @row.css("td")[3].text.to_i
  end

  def club
    @row.css("td")[4].text.strip
  end

  def date_of_birth
    dob = @row.css("td")[2].text.gsub(/([0-9]{,2}\s\w*\s[0-9]{4})/, "$1")
    Date.parse(dob)
  rescue ArgumentError
    nil
  end
end
