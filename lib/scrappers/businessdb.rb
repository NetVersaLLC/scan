class Businessdb < AbstractScrapper
  # http://search.businessdb.com/?q=%20Pinnacle%20Homes&c=United%20States%20of%20America
  # Request:
  # - Business name
  # Sort:
  # - Business name

  def execute
		url = "http://search.businessdb.com/?q=#{URI::encode(@data['business'])}&c=#{URI::encode('United States of America')}"
		page = Nokogiri::HTML(RestClient.get(url))

  	page.css("span.dashSearchCompanyName").each do |item|
      next unless match_name?(item, @data['business'])

      return {
        'status' => :listed,
        'listed_name' => item.text.strip,
        'listed_address' => '',
        'listed_phone' => '',
        'listed_url' => item.parent.attr("href")
      }
  	end

    return {'status' => :unlisted}
	end

end
