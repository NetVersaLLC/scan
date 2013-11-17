require 'awesome_print'

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
      businessFound['listed_address'] = page.at_xpath('//div[@id="zp_div_result_1"]//p').text

      subpage = Nokogiri::HTML(RestClient.get(link))
      businessFound['status'] = :listed
      phone = subpage.at_css("span.head_phone.iconsprite.inprofile_head").text
      businessFound['listed_phone'] = phone
    end
    businessFound
  end

end




