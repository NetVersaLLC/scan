class Insiderpages < AbstractScrapper
  # http://www.insiderpages.com/search/search?query=Signal+Lounge&location=92869&commit=Go!
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://www.insiderpages.com/search/search?query=#{CGI.escape(@data['business'])}&location=#{@data['zip']}&commit=Go!"
    page = Nokogiri::HTML(RestClient.get(url))

    businessFound = {}

    page.css("div.search_result").each do |item|
      next unless match_name?(item.css("h2 a"), @data['business'])

      businessUrl = "http://www.insiderpages.com" + item.css("h2 a").attr("href")
      subpage = Nokogiri::HTML(RestClient.get(businessUrl))

      # Sort by ZIP
      next unless subpage.css("span.postal-code").text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = subpage.css("p.tel").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ subpage.css("span.street-address"),
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

end
