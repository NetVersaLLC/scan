class Freebusinessdirectory < AbstractScrapper
  # http://freebusinessdirectory.com/search_res.php?str=Cavatore%20Italian%20Restaurant&p=1&n=50&t=2
  # Request:
  # - Business name
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://freebusinessdirectory.com/search_res.php?str=#{CGI.escape(@data['business'])}&p=1&n=50&t=2"
    page = Nokogiri::HTML(RestClient.get(url))

    page.css("a.search_result_name").each do |item|
      next unless match_name?(item, @data['business'])

      businessUrl = "http://freebusinessdirectory.com/" + item.attr("href")
      subpage = Nokogiri::HTML(RestClient.get(businessUrl))

      # Sort by ZIP
      next unless subpage.css("div.result_descr_small br")[0].next.text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = subpage.css("td[@width='196'] div.result_descr_small br")[1].next.text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ subpage.css("div.result_descr_small br")[0].previous,
                        subpage.css("div.result_descr_small br")[0].next]

      return {
        'status' => :listed,
        'listed_name' => item.text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
