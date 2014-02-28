class Expressbusinessdirectory < AbstractScrapper
  # http://www.expressbusinessdirectory.com/businesses/Inkling-Tattoo-Gallery-92869/
  # Search by:
  # - Business name
  # - ZIP

  def execute
    businessfixed = format_business(@data['business'])
    url = "http://www.expressbusinessdirectory.com/businesses/#{businessfixed}" + "-" + @data['zip'] + "/"
    page = Nokogiri::HTML(RestClient.get(url))

    page.xpath("//div[@id='content-left']/b/a").each do |item|
      next unless item.text.gsub('&', 'and') =~ /#{@data['business'].gsub('&', 'and')}/i
      
      businessUrl = item.attr("href")
      subpage = Nokogiri::HTML(RestClient.get(businessUrl))

      return {
        'status' => :listed,
        'listed_name' => item.text.strip,
        'listed_address' => subpage.xpath('//*[@id="content-left"]/text()[5]').to_s.strip.split(" ,").join,
        'listed_phone' => subpage.xpath('//*[@id="content-left"]/text()[6]').to_s.gsub("phone:","").strip,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

  def format_business(business)
    business.gsub(' ', '-').gsub('&', '')
  end

end
