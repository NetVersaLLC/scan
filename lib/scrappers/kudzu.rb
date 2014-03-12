class Kudzu < AbstractScrapper
  # http://www.kudzu.com/controller.jsp?N=0&searchVal=Jodie%27s+Restaurant&currentLocation=94706&searchType=keyword&Ns=P_PremiumPlacement
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url="http://www.kudzu.com/controller.jsp?N=0&searchVal=#{CGI.escape(@data['business'])}&currentLocation=#{@data['zip']}&searchType=keyword&Ns=P_PremiumPlacement"
    page = Nokogiri::HTML(RestClient.get(url))

    page.css("div.nvrBox").each do |item|
      next unless match_name?(item.css("h3 a"), @data['business'])

      # Sort by ZIP
      next unless item.css("div.nvrAddr").text =~ /#{@data['zip']}/i

      businessUrl = "http://www.kudzu.com" + item.css("h3 a").attr("href")
      subpage = Nokogiri::HTML(RestClient.get(businessUrl))

      # Sort by business phone number
      businessPhone = subpage.xpath("//span[@itemprop='telephone']").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      return {
        'status' => subpage.xpath("//a[@class='topNavLink']").length > 0 ? :listed : :claimed,
        'listed_name' => item.css("h3 a").text.strip,
        'listed_address' => item.css("div.nvrAddr").text.gsub(/\n+|\r+|\t+/, " ").strip,
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
