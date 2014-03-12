class Yellowwiz < AbstractScrapper
  # http://www.yellowwiz.com/Business_Listings.php?name=Fine+Art+Gallery&city=Orange&state=CA&current=1&Submit=Search
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url="http://www.yellowwiz.com/Business_Listings.php?name=#{CGI.escape(@data['business'])}&city=#{CGI.escape(@data['city'])}&state=#{CGI.escape(@data['state_short'])}&current=1&Submit=Search"
    page = Nokogiri::HTML(RestClient.get(url))

    page.css("table.vc_result").each do |item|
      next unless match_name?(item.css("span a"), @data['business'])

      # Sort by ZIP
      next unless item.css("span.cAddText").text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = item.css("font").text.gsub(/\n+/,'').strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      return {
        'status' => :listed,
        'listed_name' => item.css("span a").text.strip,
        'listed_address' => item.css("span.cAddText")[0].text.strip,
        'listed_phone' => businessPhone,
        'listed_url' => "http://www.yellowwiz.com"+item.css("span a").attr("href")
      }
    end

    return {'status' => :unlisted}
  end

end
