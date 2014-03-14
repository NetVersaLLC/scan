class Manta < AbstractScrapper
  # http://www.manta.com/mb?search=Inkling+Tattoo+Gallery+92869&search_source=nav
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://www.manta.com/mb?search=#{CGI.escape(@data['business'])}+#{@data['zip']}&search_source=nav"
    page = Nokogiri::HTML(RestClient.get(url))

    page.css("h2[@itemprop='name'] a").each do |item|
      next unless match_name?(item, @data['business'])

      businessUrl = item.attr("href")
      subpage = Nokogiri::HTML(RestClient.get(businessUrl))

      # Sort by ZIP
      next unless subpage.css("span[@itemprop='postalCode']").text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = subpage.css("span[@itemprop='telephone']").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ subpage.css("div[@itemprop='streetAddress']"),
                        subpage.css("span[@itemprop='addressLocality']"),
                        subpage.css("span[@itemprop='addressRegion']"),
                        subpage.css("span[@itemprop='postalCode']")]

      return {
        'status' => subpage.css("span.claimable_link").blank? ? :claimed : :listed,
        'listed_name' => item.text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => phone_form(businessPhone),
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
