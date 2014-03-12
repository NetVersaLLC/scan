class Merchantcircle < AbstractScrapper
  # http://www.merchantcircle.com/search?q=Inkling+Tattoo+Gallery&qn=92869
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    businessfixed = @data['business'].gsub(",","")
    url = "http://www.merchantcircle.com/search?q=#{businessfixed}&qn=#{@data['zip']}"

    #begin
      page = Nokogiri::HTML(RestClient.get(url))

      page.css("li.result").each do |item|
        next unless match_name?(item.css("header a h3"), @data['business'])

        # Sort by ZIP
        next unless item.css("a.directions").text =~ /#{@data['zip']}/i

        businessUrl = item.css("header a")[0].attr("href")
        subpage = Nokogiri::HTML(RestClient.get(businessUrl))

        # Sort by business phone number
        businessPhone = subpage.css("span[@itemprop='telephone']").text.strip
        if !@data['phone'].blank?
          next unless  phone_form(@data['phone']) == phone_form(businessPhone)
        end

        address_parts = [ subpage.css("span[@itemprop='streetAddress']"),
                          subpage.css("span[@itemprop='addressLocality']"),
                          subpage.css("span[@itemprop='addressRegion']"),
                          subpage.css("span[@itemprop='postalCode']")]

        return {
          'status' => subpage.css("a#claim-business").length > 0 ? :listed : :claimed,
          'listed_name' => item.css("header a h3").text.strip,
          'listed_address' => address_form(address_parts),
          'listed_phone' => businessPhone,
          'listed_url' => businessUrl
        }
      end

    #rescue
      #businessFound['status'] = :unlisted
    #end

    return {'status' => :unlisted}
  end

end
