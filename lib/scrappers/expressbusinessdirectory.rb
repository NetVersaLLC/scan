class Expressbusinessdirectory < AbstractScrapper
  # http://www.expressbusinessdirectory.com/businesses/Inkling-Tattoo-Gallery-92869/
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    businessfixed = format_business(@data['business'])
    url = "http://www.expressbusinessdirectory.com/businesses/#{businessfixed}" + "-" + @data['zip'] + "/"
    page = Nokogiri::HTML(RestClient.get(url))

    page.xpath("//div[@id='content-left']/b/a").each do |item|
      next unless item.text.strip.gsub('&', 'and').downcase == @data['business'].gsub('&', 'and').downcase
      
      businessUrl = item.attr("href")
      subpage = Nokogiri::HTML(RestClient.get(businessUrl))

      # Sort by ZIP
      next unless subpage.xpath('//*[@id="content-left"]/text()[5]').to_s =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = subpage.xpath('//*[@id="content-left"]/text()[6]').to_s.gsub("phone:","").strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      return {
        'status' => :listed,
        'listed_name' => item.text.strip,
        'listed_address' => subpage.xpath('//*[@id="content-left"]/text()[5]').to_s.strip.split(" ,").join,
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

  def format_business(business)
    business.gsub(' ', '-').gsub('&', '')
  end

end
