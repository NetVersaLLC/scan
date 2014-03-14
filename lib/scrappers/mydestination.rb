class Mydestination < AbstractScrapper
  # http://www.mydestination.com/orlando/search-results?q=The+Pub+Orlando
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://www.mydestination.com/#{place}/search-results?q=#{CGI.escape(@data['business'])}"
    page = Nokogiri::HTML(RestClient.get(url))

    page.css("div.browserow").each do |item|
      next unless match_name?(item.css("h2 a"), @data['business'])

      businessUrl = "http://www.mydestination.com" + item.css("h2 a")[0].attr("href")
      subpage = Nokogiri::HTML(RestClient.get(businessUrl))

      # Sort by ZIP
      next unless subpage.css("span.postal-code").text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = subpage.css("span.valContact")[0].text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ subpage.css("span.street-address"),
                        subpage.css("span.extended-address"),
                        subpage.css("span.locality"),
                        subpage.css("span.region"),
                        subpage.css("span.postal-code")]

      return {
        'status' => :listed,
        'listed_name' => item.css("h2 a").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

  def place
    case @data['state_short']
    when 'CA'
      return 'LosAngeles'
    when 'HI'
      return 'Hawaii'
    else
      return 'Orlando'
    end
  end

end
