class Getfave < AbstractScrapper
  # https://www.getfave.com/search?q=Inkling+Tattoo+Gallery&g=92869
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "https://www.getfave.com/search?q=#{CGI.escape(@data['business'])}&g=#{CGI.escape(@data['zip'])}"
    page = Nokogiri::HTML(RestClient.get(url))

    page.xpath("//div[@id='business-results']/a").each do |item|
      next unless replace_and(item.xpath(".//span[@class='name']").text.strip.downcase) == replace_and(@data['business'].downcase)

      # Sort by ZIP
      next unless item.xpath(".//span[@class='address']").text =~ /#{@data['zip']}/i

      businessUrl = item.attr("href")
      subpage = mechanize.get(businessUrl)

      # Sort by business phone number
      businessPhone = subpage.search("span.phone").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      return {
        'status' => subpage.search("a#claim").length > 0 ? :listed : :claimed,
        'listed_name' => item.xpath(".//span[@class='name']").text.strip,
        'listed_address' => item.xpath(".//span[@class='address']").text.strip,
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

  # Replace '&' with 'and'
  def replace_and(business)
    return business.gsub("&","and")
  end

end
