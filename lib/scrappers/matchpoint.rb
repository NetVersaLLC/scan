class Matchpoint < AbstractScrapper
  # http://www.matchpoint.com/dest?q=Signal+Lounge&g=92869&id=1198&jump=dummy+flow+page&from=searchForm
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
		url = "http://www.matchpoint.com/dest?q=#{CGI.escape(@data['business'])}&g=#{@data['zip']}&id=1198&jump=dummy+flow+page&from=searchForm"
		page = Nokogiri::HTML(RestClient.get(url)) 

		page.css("div.mp-result-mid").each do |item|
      next unless match_name?(item.css("h3 a"), @data['business'])

      # Sort by ZIP
      next unless item.css("span.address").text =~ /#{@data['zip']}/i

      businessUrl = "http://www.matchpoint.com" + item.css("h3 a").attr("href")
      subpage = Nokogiri::HTML(RestClient.get(businessUrl))

      # Sort by business phone number
      businessPhone = subpage.css("strong.phone").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ subpage.css("div.mpBppAddress em[1]"),
                        subpage.css("div.mpBppAddress span.mpCity"),
                        subpage.css("div.mpBppAddress span.mpState"),
                        subpage.css("div.mpBppAddress span.mpState")[0].next]

      return {
        'status' => subpage.css("div.mpVerified").length > 0 ? :claimed : :listed,
        'listed_name' => item.css("h3 a").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
	end

end
