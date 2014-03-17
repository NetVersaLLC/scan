class Ziplocal < AbstractScrapper
  # http://www.ziplocal.com/list.jsp?lang=0&nt=N&na=Inkling%20Tattoo%20Gallery&ct=Orange&pr=CA
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://www.ziplocal.com/list.jsp?lang=0&nt=N&na=#{URI::encode(@data['business'])}&ct=#{URI::encode(@data['city'])}&pr=#{@data['state_short']}"
    page = Nokogiri::HTML(RestClient.get(url))
    
    page.css("div.listing.vcard.cfix").each do |item|
      next unless match_name?(item.xpath(".//a[@class='url']"), @data['business'])

      businessUrl = "http://www.ziplocal.com" + item.xpath(".//a[@class='url']")[0].attr("href")
      subpage = mechanize.get(businessUrl)

      # Sort by ZIP
      next unless subpage.search("span.postal-code").text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = subpage.search("p.phone_header").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ subpage.search("span.street-address"),
                        subpage.search("span.locality"),
                        subpage.search("span.region"),
                        subpage.search("span.postal-code")]

      return {
        'status' => :listed,
        'listed_name' => item.xpath(".//a[@class='url']").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
