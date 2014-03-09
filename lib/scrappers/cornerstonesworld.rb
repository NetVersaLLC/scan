class Cornerstonesworld < AbstractScrapper
  # http://www.cornerstonesworld.com/en/directory/country/USA/state/CA/keyword/Inkling+Tattoo+Gallery/new
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://www.cornerstonesworld.com/en/directory/country/USA/state/#{@data['state_short']}/keyword/#{CGI.escape(@data['business'])}/new"
    page = mechanize.get(url)

    page.search("td.dirlisttext").each do |item|
      next unless replace_and(item.search("span.titlesmalldblue").text.strip.gsub(/\t+|\n+/, '').downcase) == replace_and(@data['business'].downcase)

      # Sort by ZIP
      next unless item.search("div.highslide-maincontent p")[0].search("br")[1].previous.text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = item.search("div.highslide-maincontent p")[1].search("b")[0].next.text.gsub(".", "")[/\b[\s()\d-]{6,}\d\b/]
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ item.search("div.highslide-maincontent p")[0].search("br")[0].previous,
                        item.search("div.highslide-maincontent p")[0].search("br")[1].previous]

      return {
        'status' => :claimed,
        'listed_name' => item.search("span.titlesmalldblue").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => url
      }
    end

    return {'status' => :unlisted}
  end

  # replace '&'' with 'and'
  def replace_and(business)
    return business.gsub("&", "and")
  end

end
