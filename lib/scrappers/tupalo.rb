class Tupalo < AbstractScrapper
  # http://tupalo.com/en/search?q=Inkling+Tattoo+Gallery&city_select=Orange%2C+CA
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://tupalo.com/en/search?q=#{CGI.escape(@data['business'])}&city_select=#{CGI.escape(@data['city'])}%2C+#{CGI.escape(@data['state_short'])}"
    page_nok = Nokogiri::HTML(RestClient.get(url))

    page_nok.css("div.title").each do |item|
      next unless match_name?(item.xpath(".//span[@itemprop='name']"), @data['business'])

      businessUrl = item.xpath(".//a")[0].attr("href")
      subpage = Nokogiri::HTML(RestClient.get(businessUrl))

      # Sort by ZIP
      next unless subpage.xpath("//span[@itemprop='postalCode']").text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = subpage.xpath("//span[@itemprop='telephone']").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ subpage.xpath("//span[@itemprop='streetAddress']"),
                        subpage.xpath("//span[@itemprop='addressLocality']"),
                        subpage.xpath("//span[@itemprop='addressRegion']"),
                        subpage.xpath("//span[@itemprop='postalCode']")]

      return {
        'status' => subpage.css("span.al.button.small.color.green").length > 0 ? :listed : :claimed,
        'listed_name' => item.xpath(".//span[@itemprop='name']").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
