class Digabusiness < AbstractScrapper
	# http://www.digabusiness.com/index.php?search=University+of+West+Florida
  # Request:
  # - Business name
  # Sort:
  # - Business name

  def execute
  	url = "http://www.digabusiness.com/index.php?search=#{CGI.escape(@data['business'])}"
  	page = mechanize.get(url)

  	page.search("td.link a").each do |item|
      next unless match_name?(item.search("./strong"), @data['business'])
      
      return {
        'status' => :listed,
        'listed_name' => item.search("./strong").text.strip,
        'listed_address' => '',
        'listed_phone' => '',
        'listed_url' => item.attr("href")
      }
  	end

    return {'status' => :unlisted}
	end

end
