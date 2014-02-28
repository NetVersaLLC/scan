class Tupalo < AbstractScrapper
  # http://tupalo.com/en/search?q=Inkling+Tattoo+Gallery&city_select=Orange%2C+CA
  # Search by:
  # - Business name
  # - ZIP
  
  def execute
    url = "http://tupalo.com/en/search?q=#{CGI.escape(@data['business'])}&city_select=#{CGI.escape(@data['city'])}%2C+#{CGI.escape(@data['state_short'])}"
    page_nok = Nokogiri::HTML(RestClient.get(url))

    page_nok.css("div.title").each do |item|
      next unless item.xpath(".//span[@itemprop='name']").text =~ /#{@data['business']}/i

      businessUrl = item.xpath(".//a")[0].attr("href")
      subpage = Nokogiri::HTML(RestClient.get(businessUrl))

      address_parts = [ subpage.xpath("//span[@itemprop='streetAddress']"),
                          subpage.xpath("//span[@itemprop='addressLocality']"),
                          subpage.xpath("//span[@itemprop='addressRegion']"),
                          subpage.xpath("//span[@itemprop='postalCode']")]

      return {
        'status' => subpage.css("span.al.button.small.color.green").length > 0 ? :listed : :claimed,
        'listed_name' => item.xpath(".//span[@itemprop='name']").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => subpage.xpath("//span[@itemprop='telephone']").text.strip,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
