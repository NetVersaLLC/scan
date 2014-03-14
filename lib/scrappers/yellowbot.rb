class Yellowbot < AbstractScrapper
  # http://www.yellowbot.com/search?lat=&long=&q=Inkling+Tattoo+Gallery&place=92869
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://www.yellowbot.com/search?lat=&long=&q=#{CGI.escape(@data['business'])}&place=#{@data['zip']}"
    page = Nokogiri::HTML(RestClient.get(url))

    page.css("div.resultInner").each do |item|
      next unless match_name?(item.css("h3 a"), @data['business'])

      # Sort by ZIP
      next unless item.css("span.zip").text =~ /#{@data['zip']}/i

      businessUrl = "http://www.yellowbot.com" + item.css("h3 a")[0].attr("href")
      subpage = Nokogiri::HTML(RestClient.get(businessUrl))

      # Sort by business phone number
      businessPhone = subpage.css("dd.tel").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ subpage.css("span.street-address")[0],
                        subpage.css("span.locality")[0],
                        subpage.css("span.region")[0],
                        subpage.css("span.postal-code")[0]]

      return {
        'status' => subpage.css("a.claim-business").blank? ? :claimed : :listed,
        'listed_name' => item.css("h3 a").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
