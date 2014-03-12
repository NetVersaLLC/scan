class Ebusinesspages < AbstractScrapper
  # http://ebusinesspages.com/7145388748.tel
  # Request:
  # - Business phone number
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
		url = "http://ebusinesspages.com/#{phone_form(@data['phone'])}.tel"
		page = Nokogiri::HTML(RestClient.get(url))

		page.css("div.listCompany a").each do |item|
      next unless match_name?(item, @data['business'])

      businessUrl = "http://ebusinesspages.com/" + item.attr("href")
      subpage = Nokogiri::HTML(RestClient.get(businessUrl))

      # Sort by ZIP
      next unless subpage.xpath("//span[@itemprop='postalCode']").text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = subpage.xpath("//a[@itemprop='tel']").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ subpage.xpath("//span[@itemprop='street-address']"),
                        subpage.xpath("//span[@itemprop='locality']"),
                        subpage.xpath("//span[@itemprop='region']"),
                        subpage.xpath("//span[@itemprop='postalCode']")]

      return {
        'status' => :claimed,
        'listed_name' => item.text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
		end

    return {'status' => :unlisted}
	end

end
