class Zippro < AbstractScrapper

  def execute
    @data['businessfixed'] = @data['business'].gsub(" ", "+").gsub("-", "+")

    businessFound = {
        'status' => :unlisted
    }
    url = "http://#{@data['zip']}.zip.pro/#{@data['businessfixed']}"
    page = Nokogiri::HTML(RestClient.get(url))
    if page.css("div.organicListing").size > 0
      link = page.css("a.result-title")
      businessFound['listed_name'] = link.text.strip
      link = link[0]["href"]
      businessFound['listed_url'] = link
      subpage = Nokogiri::HTML(RestClient.get(link))
      businessFound['status'] = :listed
      phone = subpage.at_css("span.head_phone.iconsprite.inprofile_head").text
      businessFound['listed_phone'] = phone
      address = subpage.at_xpath('//*[@id="profile_header"]/div/div[3]/div[1]/div[3]/span/span[1]').text + subpage.at_xpath('//*[@id="profile_header"]/div/div[3]/div[1]/div[3]/span/span[2]').text + subpage.at_xpath('//*[@id="profile_header"]/div/div[3]/div[1]/div[3]/span/span[3]').text + subpage.at_xpath('//*[@id="profile_header"]/div/div[3]/div[1]/div[3]/span/span[4]').text
      businessFound['listed_address'] = address
    end
    businessFound
  end

end




