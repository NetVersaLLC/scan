class Uscity < AbstractScrapper
  # http://uscity.net/orange-ca/inkling-tattoo-gallery
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    cityfixed = (@data['city'] + ' ' + @data['state_short']).gsub(" ", "-")
    businessfixed = @data['business'].gsub('&','').gsub(/[ ']/, "-")

    url = "http://uscity.net/#{cityfixed}/#{businessfixed}"
    page = Nokogiri::HTML(RestClient.get(url))

    page.css("div.boxborder").each do |item|
      next unless match_name?(item.css("h3 a strong"), @data['business'])

      # Sort by ZIP
      next unless item.css("div.addressbox strong").text =~ /#{@data['zip']}/i

      businessUrl = item.css("h3 a")[0].attr("href")
      subpage = Nokogiri::HTML(RestClient.get(businessUrl))

      # Sort by business phone number
      businessPhone = subpage.css("span[@itemprop='telephone']").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ subpage.css("span[@itemprop='streetAddress']"),
                        subpage.css("span[@itemprop='addressLocality']"),
                        subpage.css("span[@itemprop='addressRegion']"),
                        subpage.css("span[@itemprop='postalCode']")]

      return {
        'status' => subpage.css("p.mart1").blank? ? :listed : :claimed,
        'listed_name' => item.css("h3 a strong").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
