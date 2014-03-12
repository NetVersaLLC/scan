class Yellowee < AbstractScrapper
  # http://www.yellowee.com/search?what=Protect+You+Home+-+Adt+Authorized+Dealer&where=Orange%2C+California%2C+United+States
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://www.yellowee.com/search?what=#{CGI.escape(@data['business'])}&where=#{CGI.escape(@data['city'])}%2C+#{CGI.escape(@data['state'])}%2C+United+States"
    page = Nokogiri::HTML(RestClient.get(url))

    page.css("div.business_info").each do |item|
      next unless replace_and(item.css("div.title a h3").text.strip.downcase) == replace_and(@data['business'].downcase)

      businessUrl = "http://www.yellowee.com" + item.css("div.title a").attr("href")
      subpage = Nokogiri::HTML(RestClient.get(businessUrl))

      # Sort by ZIP
      next unless subpage.css("span.postal-code").text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = subpage.css("span.tel").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ subpage.css("span.street-address"),
                        subpage.css("span.locality"),
                        subpage.css("span.region"),
                        subpage.css("span.postal-code")]

      return {
        'status' => subpage.xpath("//a[@title='Claim Business']").length > 0 ? :listed : :claimed,
        'listed_name' => item.css("div.title a h3").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

  def replace_and(business)
    business.gsub("&","and")
  end

end
