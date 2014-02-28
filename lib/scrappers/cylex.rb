class Cylex < AbstractScrapper
  # http://www.cylex-usa.com/s?q=Signal+Lounge&c=Orange&p=1
  # Search by:
  # - Business name
  # - ZIP

  def execute
    url = "http://www.cylex-usa.com/s?q=#{CGI.escape(@data['business'])}&c=#{CGI.escape(@data['city'])}&p=1"
    
    begin
      page = Nokogiri::HTML(RestClient.get(url))
    rescue
      return {'status' => :unlisted}
    end
    
    page.css('div.lm-result-companyData').each do |item|
      next unless item.xpath(".//h2/a").text =~ /#{@data['business']}/i

      address_parts = [ item.xpath(".//span[@itemprop='streetAddress']"),
                        item.xpath(".//span[@itemprop='addressLocality']"),
                        item.xpath(".//span[@class='region']"),
                        item.xpath(".//span[@itemprop='postalCode']")]

      return {
        'status' => :listed,
        'listed_name' => item.xpath(".//h2/a").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => item.xpath(".//span[@itemprop='telephone']").text.strip,
        'listed_url' => item.xpath(".//h2/a")[0].attr("href")
      }
    end

    return {'status' => :unlisted}
  end

end
