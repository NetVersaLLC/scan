class Hyplo < AbstractScrapper
  # http://www.hyplo.com/search.php?page=1&q=Connect+Plumbing&ql=92805
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP

  def execute
    url = "http://www.hyplo.com/search.php?page=1&q=#{CGI.escape(@data['business'])}&ql=#{@data['zip']}"
    page = Nokogiri::HTML(RestClient.get(url))

    page.css("div.foundsite").each do |item|
      next unless match_name?(item.css("div.title a"), @data['business'])

      # Sort by ZIP
      businessAddress = item.css("div.description")[1].text.strip
      next unless item.css("div.description")[1].text =~ /#{@data['zip']}/i

      return {
        'status' => :listed,
        'listed_name' => item.css("div.title a").text.strip,
        'listed_address' => businessAddress,
        'listed_phone' => "",
        'listed_url' => "http://www.hyplo.com" + item.css("div.title a")[0].attr("href")
      }
    end

    return {'status' => :unlisted}
  end

end
