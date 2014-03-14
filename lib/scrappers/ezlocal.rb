class Ezlocal < AbstractScrapper
  # http://ezlocal.com/search/?q=Inkling+Tattoo+Gallery&by=92869&z=
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://ezlocal.com/search/?q=#{CGI.escape(@data['business'])}&by=#{@data['zip']}&z="
    page = Nokogiri::HTML(RestClient.get(url))

    page.css("div.businessdetails").each do |item|
      next unless match_name?(item.css("h3 a"), @data['business'])

      # Sort by ZIP
      next unless item.css("span.postal-code").text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = item.css("p.tel").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ item.css("span.street-address"),
                        item.css("span.locality"),
                        item.css("span.region"),
                        item.css("span.postal-code")]

      return {
        'status' => item.parent.css("div.claim").blank? ? :claimed : :listed,
        'listed_name' => item.css("h3 a").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => "http://ezlocal.com" + item.css("h3 a")[0].attr("href")
      }
    end

    return {'status' => :unlisted}
  end

end
