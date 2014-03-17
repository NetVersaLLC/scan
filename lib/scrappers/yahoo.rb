class Yahoo < AbstractScrapper
  # http://local.search.yahoo.com/search?p=Inkling Tattoo Gallery&addr=Orange, CA&fr2=sb-top&type_param=
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    businessFound = {'status' => :unlisted}

    url = "http://local.search.yahoo.com/search"
    html = RestClient.get(url, { :params => { :p => @data['business'], 
                                              :addr => @data['zip'], 
                                              :fr2 => 'sb-top', 
                                              :type_param => '' 
                                            } 
                                }
                          )
    page = Nokogiri::HTML(html)

    page.css("ol.res div.content").each do |item|
      businessUrl = item.css("h4 a")[0].attr("href")
      subpage = Nokogiri::HTML(RestClient.get(businessUrl))
      next unless match_name?(subpage.css("h1.kg-style1"), @data['business'])

      # Sort by ZIP
      next unless subpage.css("div.yl-biz-addr").text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = subpage.css("li.yl-biz-ph").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      businessFound['listed_phone'] = businessPhone
      businessFound['listed_name'] = subpage.css("h1.kg-style1").text.strip
      businessFound['listed_url'] = businessUrl


      businessFound['status'] = :listed
      subpage.css("span.merchant-ver").each do |div|
        businessFound['status'] = :claimed
      end

      businessFound['listed_address'] = subpage.css("div.yl-biz-addr").text.strip

      return businessFound
    end

    businessFound
  end

end
