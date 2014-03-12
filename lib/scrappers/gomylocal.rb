class Gomylocal < AbstractScrapper
  # http://www.gomylocal.com/listings/92869-Signal+Lounge
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://www.gomylocal.com/listings/" + @data['zip'] + "-" + CGI.escape(@data['business'].gsub(",",""))
    page = Nokogiri::HTML(RestClient.get(url))

    page.css("a.links_12pt_bold").each do |item|
      next unless match_name?(item, @data['business'])

      businessName = item.text.strip
      businessUrl = item.attr("href")

      5.times {item = item.parent}

      street_addr = item.next.xpath("./td[1]").text.inspect.gsub('\u00A0', "").gsub("\"", "").strip
      state_addr = item.next.next.xpath("./td[1]").text.gsub(/\t+|\n+|\r+/, '').inspect.gsub('\u00A0', " ").gsub("\"", "").strip

      # Sort by ZIP
      next unless item.next.next.xpath("./td[1]").text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = item.next.next.next.xpath("./td[1]").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      return {
        'status' => :claimed,
        'listed_name' => businessName,
        'listed_address' => street_addr + ", " + state_addr,
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
