class Localcom < AbstractScrapper
  # http://www.local.com/business/results/?keyword=Jodie%27s+Restaurant&location=94706
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://www.local.com/business/results/?keyword=#{CGI.escape(@data['business'])}&location=#{CGI.escape(@data['zip'])}"
    page = mechanize.get(url)

    page.search("div.courtesyListing").each do |item|
      next unless match_name?(item.search("h2"), @data['business'])

      businessUrl = "http://www.local.com" + item.search("h2")[0].parent.attr("href")
      subpage = mechanize.get(businessUrl)

      # Sort by ZIP
      next unless subpage.search("span.postal-code").text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = subpage.search("strong.tel").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ subpage.search("span.street-address"),
                        subpage.search("span.locality"),
                        subpage.search("span.region"),
                        subpage.search("span.postal-code")]

      return {
        'status' => :listed,
        'listed_name' => item.search("h2").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
