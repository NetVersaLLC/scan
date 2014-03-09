class Justclicklocal < AbstractScrapper
  # http://www.justclicklocal.com/citydir/Orange-California--Inkling-Tattoo-Gallery.html
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    data_cityfixed = @data['city'].gsub(" ","-")
    data_businessfixed = @data['business'].gsub(" ","-").gsub(" & ","").gsub(",","")

    url = "http://www.justclicklocal.com/citydir/#{data_cityfixed}-#{@data['state']}--#{data_businessfixed}.html"
    page = mechanize.get(url)

    page.search("div.m").each do |item|
      next unless match_name?(item.search("a.link"), @data['business'])

      # Sort by ZIP
      next unless item.search("span.address").text =~ /#{@data['city']}/i

      # Sort by business phone number
      businessPhone = item.search("span.phone-num").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      return {
        'status' => :listed,
        'listed_name' => item.search("a.link").text.strip,
        'listed_address' => item.search("span.address").text.strip,
        'listed_phone' => businessPhone,
        'listed_url' => ''
      }
    end

    return {'status' => :unlisted}
  end

end
