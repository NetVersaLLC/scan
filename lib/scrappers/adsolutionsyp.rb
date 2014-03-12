class Adsolutionsyp < AbstractScrapper
  # http://www.yellowpages.com/Orange-CA/Inkling%20Tattoo%20Gallery
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
		url = "http://www.yellowpages.com/#{URI::encode(@data['city'])}-#{URI::encode(@data['state_short'])}/#{URI::encode(@data['business'])}"
		page = mechanize.get(url)

		page.search("div.business-container-inner").each do |item|
      next unless match_name?(item.search("a.url"), @data['business'])

      # Sort by ZIP
      next unless item.search("span.postal-code").text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = item.search("span.business-phone").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ item.search("span.street-address"),
                        item.search("span.locality"),
                        item.search("span.region"),
                        item.search("span.postal-code")]

      return {
        'status' => :claimed,
        'listed_name' => item.search("a.url").text.strip,
        'listed_address' => address_form(address_parts).gsub(",,", ","),
        'listed_phone' => businessPhone,
        'listed_url' => item.search("a.url")[0].attr("href")
      }
		end

    return {'status' => :unlisted}
	end

end
