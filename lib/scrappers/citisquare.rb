class Citisquare < AbstractScrapper
  # http://citysquares.com/s/business?t=Inkling+Tattoo+Gallery
  # Request:
  # - Business name
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://citysquares.com/s/business?t=#{URI::encode(@data['business'])}"
    page = mechanize.get(url)

    page.search("div#cs-biz-listing ul li").each do |item|
      next unless match_name?(item.search(".//a"), @data['business'])

      businessUrl = item.search(".//a")[0]['href']
      subpage = mechanize.get(businessUrl)

      # Sort by ZIP
      if !subpage.search("span.postal-code").text.blank?
        next unless subpage.search("span.postal-code").text =~ /#{@data['zip']}/i
      elsif !subpage.search("span.locality").text.blank?
        next unless subpage.search("span.locality").text =~ /#{@data['city']}/i
      end

      if subpage.search('.phone.tel')[0]
        businessPhone = subpage.search('.phone.tel').text.strip
      else
        businessPhone = ""
      end

      # Sort by business phone number
      if !@data['phone'].blank? && !businessPhone.blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ subpage.search("span.street-address"),
                        subpage.search("span.locality"),
                        subpage.search("span.region"),
                        subpage.search("span.postal-code")]

      return {
        'status' => item['class'] == "paid" ? :claimed : :listed,
        'listed_name' => item.search(".//a").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
