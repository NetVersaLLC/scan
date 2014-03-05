class Ibegin < AbstractScrapper
  # http://www.ibegin.com/search/phone/?phone=510-526-1109
  # Request:
  # - Business phone number
  # Sort:
  # - Business name
  # - ZIP

  def execute
    @use_proxy = true

    businessPhone = phone_form(@data['phone'])
    url = "http://www.ibegin.com/search/phone/?phone=#{CGI.escape(businessPhone)}"
    page = Nokogiri::HTML(rest_client.get(url))

    page.xpath("//div[@class='business']").each do |item|
      next unless match_name?(item.xpath(".//strong/a"), @data['business'])

      # Sort by ZIP
      next unless item.xpath(".//small").text =~ /#{@data['zip']}/i

      return {
        'status' => :listed,
        'listed_name' => item.xpath(".//strong/a").text.strip,
        'listed_address' => item.xpath(".//small").text.strip,
        'listed_phone' => businessPhone,
        'listed_url' => "http://www.ibegin.com" + item.xpath(".//strong/a")[0].attr("href")
      }
    end

    return {'status' => :unlisted}
  end

end
