class Byzlyst < AbstractScrapper
  # http://byzlyst.com/?s=Pinnacle+Homes&cat=
  # Request:
  # - Business name
  # Sort:
  # - Business name

  def execute
  	businessfixed = @data['business'].gsub("'", '%E2%80%99')
		url = "http://byzlyst.com/?s=#{CGI.escape(businessfixed)}&cat="
		page = mechanize.get(url)
		
		page.search("h2.ititle a").each do |item|
      next unless item.text.inspect.gsub('\u2019', "").gsub("\"", "").strip == @data['business'].gsub("'", "")

      return {
        'status' => :listed,
        'listed_name' => item.text.strip,
        'listed_address' => "",
        'listed_phone' => "",
        'listed_url' => item.attr("href")
      }
		end

    return {'status' => :unlisted}
	end

end
