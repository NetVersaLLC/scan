class Citygrid < AbstractScrapper
  # http://www.citygrid.com/places/search?what=Signal+Lounge&where=92869
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://www.citygrid.com/places/search?what=#{CGI.escape(@data['business'])}&where=#{@data['zip']}"
    page = Nokogiri::HTML(RestClient.get(url))

    page.css("a.search_result_name").each do |item|
      next unless match_name?(item, @data['business'])

      businessUrl = "http://www.citygrid.com" + item.attr("href")
      subpage = Nokogiri::HTML(RestClient.get(businessUrl))

      # Sort by ZIP
      next unless subpage.css("span.address br")[0].next.text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = subpage.css("span.phone").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ subpage.css("span.address br")[0].previous,
                        subpage.css("span.address br")[0].next]

      return {
        'status' => subpage.css("div.claim_business").blank? ? :claimed : :listed,
        'listed_name' => item.text.strip,
        'listed_address' => address_form(address_parts).gsub(/\n+|\r+|\t+/, " "),
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
