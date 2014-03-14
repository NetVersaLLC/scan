class Mojopages < AbstractScrapper
  # http://www.mojopages.com/biz/find?areaCode=714&exchange=538&phoneNumber=8748
  # Request:
  # - Business phone number
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    business_phone = phone_form(@data['phone'])
    url = "http://www.mojopages.com/biz/find?areaCode=#{business_phone[0..2]}&exchange=#{business_phone[3..5]}&phoneNumber=#{business_phone[6..9]}"
    page = Nokogiri::HTML(RestClient.get(url))

    page.css("div.advertise_content div.center").each do |item|
      next unless match_name?(item.css("h4"), @data['business'])

      # Sort by ZIP
      next unless item.css("br")[0].previous.text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = item.css("br")[0].next.text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end


      return {
        'status' => :listed,
        'listed_name' => item.css("h4").text.strip,
        'listed_address' => item.css("br")[0].previous.text.strip,
        'listed_phone' => businessPhone,
        'listed_url' => url
      }
    end

    return {'status' => :unlisted}
  end

end
