class Localndex < AbstractScrapper
  # http://www.localndex.com/results.aspx?wht=Signal+Lounge&whr=92869
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number
  
  def execute
		url = "http://www.localndex.com/results.aspx?wht=#{CGI.escape(@data['business'])}&whr=#{@data['zip']}"
		page = Nokogiri::HTML(RestClient.get(url))
		
		page.css("span.Verdana16 a").each do |item|
      next unless match_name?(item, @data['business'])

      info_path = item.parent.parent.parent.next

      # Sort by business phone number
      businessPhone = info_path.css("strong span[1]").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      info_path.css("strong").each do |strong|
        strong.remove
      end
      # Sort by ZIP
      next unless info_path.css("span.Verdana12 span[5]").text =~ /#{@data['zip']}/i
      address_parts = [ info_path.css("span.Verdana12 span[1]"),
                        info_path.css("span.Verdana12 span[3]"),
                        info_path.css("span.Verdana12 span[4]"),
                        info_path.css("span.Verdana12 span[5]")]

      return {
        'status' => :listed,
        'listed_name' => item.text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => item.attr("href")
      }
    end

    return {'status' => :unlisted}
	end

end
