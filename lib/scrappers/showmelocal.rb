class Showmelocal < AbstractScrapper
  # http://www.showmelocal.com/local_search.aspx?q=Inkling+Tattoo+Gallery&s=CA&c=Orange&z=92869
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute		
		url= "http://www.showmelocal.com/local_search.aspx?q=#{CGI.escape(@data['business'])}&s=#{@data['state_short']}&c=#{CGI.escape(@data['city'])}&z=#{@data['zip']}"
		page = Nokogiri::HTML(RestClient.get(url))
		
		page.css("div.serachresult").each do |item|
      next unless match_name?(item.css("div.h a"), @data['business'])

      # Sort by ZIP
      next unless item.css("div.address").text =~ /#{@data['zip']}/i

      businessUrl = "http://www.showmelocal.com/" + item.css("div.h a").attr("href")
      subpage = Nokogiri::HTML(RestClient.get(businessUrl))

      # Sort by business phone number
      businessPhone = subpage.css("span[@itemprop='postalCode']")[0]
			5.times {businessPhone = businessPhone.parent}
			businessPhone = businessPhone.css("tr[2] td[2]").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ subpage.css("span[@itemprop='streetAddress']"),
                        subpage.css("span[@itemprop='addressLocality']"),
                        subpage.css("span[@itemprop='addressRegion']"),
                        subpage.css("span[@itemprop='postalCode']")]


      return {
        'status' => subpage.css("span.textlarge img")[1].blank? ? :listed : :claimed,
        'listed_name' => item.css("div.h a").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
		end

    return {'status' => :unlisted}
	end

end
