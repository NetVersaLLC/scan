class Bizzspot < AbstractScrapper
  # http://www.bizzspot.com/results?query=Pinnacle+Homes&Submit=submit
  # Request:
  # - Business name
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url="http://www.bizzspot.com/results?query=#{CGI.escape(@data['business'])}&Submit=submit"
    page = mechanize.get(url)

    page.search("h2.color_black").each do |item|
      next unless match_name?(item.search("a"), @data['business'])

      # Sort by ZIP
      next unless item.text =~ /#{@data['zip']}/i

      businessUrl = "http://www.bizzspot.com" + item.search("a").attr("href")
      subpage = mechanize.get(businessUrl)

      # Sort by business phone number
      businessPhone = subpage.search("div.tel").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ subpage.search("span.street-address"),
                        subpage.search("span.locality"),
                        subpage.search("span.region"),
                        subpage.search("span.postal-code")]

      return {
        'status' => :listed,
        'listed_name' => item.search("a").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
