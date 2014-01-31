class Citisquare < AbstractScrapper

  def execute

    businessFound = {'status' => :unlisted}
    url= "http://citysquares.com/s/business?t=#{URI::encode(@data['business'])}"
    nok = Nokogiri::HTML(RestClient.get url)
    nok.css("div#cs-biz-listing").each do |bi|
      if (bi.css("ul li#1.free a.name").text) =~ /#{@data['business']}/i
        businessFound['listed_name'] = bi.css("ul li#1.free a.name").text.strip
        businessFound['listed_url'] = bi.css("ul li#1.free a.name").attr("href").value
        url=businessFound['listed_url']
        subpage = Nokogiri::HTML(RestClient.get "#{url}")
        if subpage.css("h1.fn.org").text =~ /#{@data['business']}/i
          businessFound['status'] = :claimed
        else
          businessFound['status'] = :listed
        end
        phone=subpage.css("div#bizInfo div#bizData.rating div#bizPhone.phone").text
        businessFound['listed_phone'] = phone.gsub("(", "").gsub(") ", "-")
        address = subpage.css("span.address.adr span.street-address").text + " " + subpage.css("span.locality").text + " " + subpage.css("span.region").text + " " + subpage.css("span.postal-code").text
        businessFound['listed_address'] = address.strip
        break
      elsif (bi.css("ul li#1.paid a#businessName.name").text) =~ /#{@data['business']}/i
        businessFound['listed_name'] = bi.css("ul li#1.paid a#businessName.name").text.strip
        businessFound['listed_url'] = bi.css("ul li#1.paid a#businessName.name").attr("href").value
        url = businessFound['listed_url']
        subpage = Nokogiri::HTML(RestClient.get "#{url}")
        if subpage.css("h1.fn.org").text =~ /#{@data['business']}/i
          businessFound['status'] = :claimed
        else
          businessFound['status'] = :listed
        end
        phone = subpage.css("span.phone.tel").text.strip
        businessFound['listed_phone'] = phone.gsub("(", "").gsub(") ", "-")
        address = subpage.css("span.address.adr span.street-address").text + " " + subpage.css("span.locality").text + " " + subpage.css("span.region").text + " " + subpage.css("span.postal-code").text
        businessFound['listed_address'] = address.strip
        break
      end
    end
    businessFound
  end
end




