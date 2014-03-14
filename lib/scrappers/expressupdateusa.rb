class Expressupdateusa < AbstractScrapper
  # http://www.expressupdate.com/search?query=7145388748
  # Request:
  # - Business phone number
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
		url = "http://www.expressupdate.com/search?query=" + phone_form(@data['phone'])
		page = Nokogiri::HTML(RestClient.get(url))  

		page.css("a.result-entry").each do |item|
      next unless match_name?(item.css("span.subhead-link"), @data['business'])

      # Sort by ZIP
      next unless item.css("br")[0].next.text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = item.css("br")[1].next.text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      return {
        'status' => :listed,
        'listed_name' => item.css("span.subhead-link").text.strip,
        'listed_address' => item.css("br")[0].next.text.strip,
        'listed_phone' => businessPhone,
        'listed_url' => "http://www.expressupdate.com" + item.attr("href")
      }
		end

    return {'status' => :unlisted}
	end

end
