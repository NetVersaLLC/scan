class Localeze < AbstractScrapper
  # http://www.neustarlocaleze.biz/directory/search?Phone=7145388748
  # Request:
  # - Business phone number
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://www.neustarlocaleze.biz/directory/search?Phone=#{phone_form(@data['phone'])}"
    page = Nokogiri::HTML(RestClient.get(url))

    page.css("div.search_listing_item").each do |item|
      next unless match_name?(item.css("div[1] h4"), @data['business'])

      # Sort by ZIP
      next unless item.css("div[1] br")[1].previous.text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = item.css("div[1] br")[1].next.text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ item.css("div[1] br")[0].previous,
                        item.css("div[1] br")[1].previous]

      return {
        'status' => :listed,
        'listed_name' => item.css("div[1] h4").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => "http://www.neustarlocaleze.biz" + item.css("div[2] a")[0].attr("href")
      }
    end

    return {'status' => :unlisted}
  end

end
