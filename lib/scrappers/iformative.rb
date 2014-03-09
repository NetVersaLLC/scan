class Iformative < AbstractScrapper
  # http://www.iformative.com/search/?q=Burger+King
  # Request:
  # - Business name
  # Sort:
  # - Business name
  # - ZIP

  def execute
    url = "http://www.iformative.com/search/?q=#{CGI.escape(@data['business'])}"
    page = Nokogiri::HTML(RestClient.get(url))

    page.css("a.title").each do |item|
      next unless match_name?(item, @data['business'])

      businessUrl = "http://www.iformative.com" + item.attr("href")
      subpage = Nokogiri::HTML(RestClient.get(businessUrl))

      # Sort by ZIP
      next unless subpage.xpath("//td[@class='info']").text =~ /#{@data['county']}/i

      return {
        'status' => :listed,
        'listed_name' => item.text.strip,
        'listed_address' => subpage.xpath("//td[@class='info']/br[3]")[0].next.text.strip,
        'listed_phone' => '',
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
