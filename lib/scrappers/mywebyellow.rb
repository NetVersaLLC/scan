class Mywebyellow < AbstractScrapper
  # http://mywebyellow.com/Search/Signal-Lounge/92869/
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://mywebyellow.com/Search/#{URI::encode(@data['business'])}/#{@data['zip']}"
    page = Nokogiri::HTML(RestClient.get(url))

    page.css("a.Link01").each do |item|
      next unless match_name?(item, @data['business'])

      businessUrl = "http://mywebyellow.com" + item.attr("href").gsub("../..", "")
      #subpage = Nokogiri::HTML(RestClient.get(businessUrl))

      # Sort by ZIP
      next unless item.parent.xpath("./span[2]").text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = item.parent.xpath("./span[1]").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ item.parent.xpath("./span[2]/br")[0].previous,
                        item.parent.xpath("./span[2]/br")[0].next]

      return {
        'status' => :listed,
        'listed_name' => item.text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
