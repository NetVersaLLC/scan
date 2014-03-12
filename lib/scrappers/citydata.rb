class Citydata < AbstractScrapper
  # http://www.city-data.com/bs/?q=Inkling+Tattoo+Gallery&w=92869
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
		url = "http://www.city-data.com/bs/?q=#{CGI.escape(@data['business'])}&w=#{@data['zip']}"
		page = Nokogiri::HTML(RestClient.get(url))

		page.css("div.bs_item").each do |item|
      next unless item.css("h3 a")[0].next.text.gsub(/#.*/, '').strip.downcase == @data['business'].downcase

      # Sort by ZIP
      next unless item.css("div.bs_f")[1].text =~ /#{@data['state_short']}/i

      # Sort by business phone number
      businessPhone = item.css("div.bs_f")[2].css("span").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ item.css("div.bs_f")[0].css("span").children,
                        item.css("div.bs_f")[1].css("span a")]

      return {
        'status' => :listed,
        'listed_name' => item.css("h3 a")[0].next.text.gsub(/#.*/, '').strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => url
      }
		end

    return {'status' => :unlisted}
	end

end
