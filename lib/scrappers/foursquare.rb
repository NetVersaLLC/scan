class Foursquare < AbstractScrapper
	# http://foursquare.com/explore?near=92869&q=Inkling%20Tattoo%20Gallery
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
		url = "http://foursquare.com/explore?near=#{@data['zip']}&q=#{URI::encode(@data['business'])}"
		page = Nokogiri::HTML(RestClient.get(url))

		page.css("div.venueBlock").each do |item|
			next unless item.css("div.venueName").text =~ /#{@data['business']}/i
				
				businessUrl = item.css("div.venueName a")[0].attr("href")
    		unless businessUrl.include?('http')
      		businessUrl = 'http://foursquare.com' + businessUrl
    		end

				subpage = Nokogiri::HTML(RestClient.get(businessUrl))

				# Sort by ZIP
				next unless subpage.xpath("//span[@itemprop='postalCode']").text =~ /#{@data['zip']}/i

      	# Sort by business phone number
      	businessPhone = subpage.css("span.tel").text.strip
    	  if !@data['phone'].blank?
  	      next unless  phone_form(@data['phone']) == phone_form(businessPhone)
	      end

				address_parts = [ subpage.xpath("//span[@itemprop='streetAddress']"),
													subpage.xpath("//span[@itemprop='addressLocality']"),
													subpage.xpath("//span[@itemprop='addressRegion']"),
													subpage.xpath("//span[@itemprop='postalCode']")]

	      return {
      	  'status' => subpage.search("[text()*='Claim it now.']") ? :listed : :claimed,
    	    'listed_name' => item.css("div.venueName").text.strip,
  	      'listed_address' => address_form(address_parts),
	        'listed_phone' => businessPhone,
        	'listed_url' => businessUrl
      	}
		end

		return {'status' => :unlisted}
	end

end
