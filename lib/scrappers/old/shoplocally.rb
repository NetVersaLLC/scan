class Shoplocally < AbstractScrapper
  # http://www.shopNewYork.com/Mcdonald%27s__10001__212-594-1964/
  # Request:
  # - Business name
  # - ZIP
  # - Business phone number
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    business_phone = phone_form(@data['phone'])

    business_phone =  business_phone[0..2] + 
                      "-"                  + 
                      business_phone[3..5] + 
                      "-"                  + 
                      business_phone[6..9]

    url = "http://www.shop#{@data['county'].gsub(" ", "")}.com/#{CGI.escape(@data['business'])}__#{@data['zip']}__#{business_phone}/"
    
    begin
      page = Nokogiri::HTML(RestClient.get(url))

      # Sort by business name
      raise unless match_name?(page.css("font.cattitles"), @data['business'])

      # Sort by ZIP
      raise unless page.css("div.inner_box div br[1]")[0].next.text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = page.css("div.inner_box div br[3]")[0].next.text.gsub(/[| phone]/, "").strip
      if !@data['phone'].blank?
        raise unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ page.css("div.inner_box div br[1]")[0].previous,
                        page.css("div.inner_box div br[1]")[0].next]

      return {
        'status' => page.xpath('//*[@id="toppod"]/tbody/tr[2]/td[2]/div/div[1]/div/a/b').length > 0 ? :listed : :claimed,
        'listed_name' => page.css("font.cattitles").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => url
      }
    rescue
      return {'status' => :unlisted}
    end
    
    return {'status' => :unlisted}
  end

end
