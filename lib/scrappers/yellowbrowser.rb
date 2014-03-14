class Yellowbrowser < AbstractScrapper
  # http://www.yellowbrowser.com/Local_Listings.php?name=Fine+Art+Gallery&city=Orange&state=CA&current=1&Submit=Search
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://www.yellowbrowser.com/Local_Listings.php?name=#{CGI.escape(@data['business'])}&city=#{CGI.escape(@data['city'])}&state=#{@data['state_short']}&current=1&Submit=Search"
    page = Nokogiri::HTML(RestClient.get(url))

    page.css("table.vc_result").each do |item|
      next unless match_name?(item.css("span.cAddName"), @data['business'])

      # Sort by ZIP
      next unless item.css("span.cAddText br")[0].next.text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = item.css("font").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ item.css("span.cAddText br")[0].previous,
                        item.css("span.cAddText br")[0].next]

      return {
        'status' => :listed,
        'listed_name' => item.css("span.cAddName").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => "http://www.yellowbrowser.com" + item.css("a.cAddViewMap")[0].attr("href")
      }
    end

    return {'status' => :unlisted}
  end

end
