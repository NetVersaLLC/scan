class Cylex < AbstractScrapper
  # http://www.cylex-usa.com/s?q=Signal+Lounge&c=Orange&p=1
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://www.cylex-usa.com/s?q=#{CGI.escape(@data['business'])}&c=#{CGI.escape(@data['city'])}&p=1"
    
    begin
      page = Nokogiri::HTML(RestClient.get(url))
    rescue
      return {'status' => :unlisted}
    end
    
    page.css('div.lm-result-companyData').each do |item|
      next unless item.xpath(".//h2/a").text.strip.inspect.gsub('\u2019', "").downcase == @data['business'].inspect.gsub("'", "").downcase

      # Sort by ZIP
      next unless item.xpath(".//span[@itemprop='postalCode']").text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = item.xpath(".//span[@itemprop='telephone']").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ item.xpath(".//span[@itemprop='streetAddress']"),
                        item.xpath(".//span[@itemprop='addressLocality']"),
                        item.xpath(".//span[@class='region']"),
                        item.xpath(".//span[@itemprop='postalCode']")]

      return {
        'status' => :listed,
        'listed_name' => item.xpath(".//h2/a").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => item.xpath(".//h2/a")[0].attr("href")
      }
    end

    return {'status' => :unlisted}
  end

end
