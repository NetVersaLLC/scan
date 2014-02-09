class Citisquare < AbstractScrapper
  # http://citysquares.com/s/business?t=Inkling+Tattoo+Gallery

  def execute
    businessFound = {'status' => :unlisted}
    url = "http://citysquares.com/s/business?t=#{URI::encode(@data['business'])}"
    page = mechanize.get(url)


    page.search("div#cs-biz-listing ul li").each do |item|
      next unless item.search(".//a").text =~ /#{@data['business']}/i

      businessFound['status'] = :listed
      if item['class'] == "paid"
        businessFound['status'] = :claimed
      end

      profile_url = item.search(".//a")[0]['href']
      profile_page = mechanize.get(profile_url)

      streetAddress = profile_page.search('span.street-address')[0].content.strip
      addressLocality = profile_page.search('span.locality')[0].content.strip
      addressRegion = profile_page.search('span.region')[0].content.strip
      postalCode = profile_page.search('span.postal-code')[0].content.strip

      businessFound['listed_name'] = profile_page.search('h1.fn.org')[0].content.strip
      businessFound['listed_address'] = [streetAddress, addressLocality, addressRegion, postalCode].join(", ")
      if profile_page.search('.phone.tel')[0]
        businessFound['listed_phone'] = profile_page.search('.phone.tel')[0].content.strip
      else
        businessFound['listed_phone'] = ""
      end
      businessFound['listed_url'] = profile_url

      return businessFound
    end

    businessFound
  end

end
