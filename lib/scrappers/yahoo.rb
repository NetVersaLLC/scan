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

    city_state = @data['city'] + ", " + @data['state_short']
    url = "http://local.search.yahoo.com/search"

    html = RestClient.get(url, { :params => { :p => @data['business'], 
                                              :addr => city_state, 
                                              :fr2 => 'sb-top', 
                                              :type_param => '' 
                                            } 
                                }
                          )
    page_nok = Nokogiri::HTML(html)

    page_nok.xpath("//div[@class='res']/div[@class='content']").each do |content|
      next unless match_name?(content.xpath("./h3/a"), @data['business'])
      
      # Sort by ZIP
      next unless content.xpath("./div[@class='address']").text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = content.xpath("./div[@class='phone']").inner_text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      businessFound['listed_phone'] = businessPhone
      businessFound['listed_name'] = content.xpath("./h3/a").inner_text.strip

      content.xpath("./h3/a").each do |a|
        url = a.attr('href')
        if url =~ /(local.yahoo.com.*)/
          businessFound['listed_url'] = "http://#{$1}"
        end
      end

      businessFound['status'] = :listed
      content.xpath("./span[@class='merchant-ver']").each do |div|
        businessFound['status'] = :claimed
      end

      content.xpath("./div[@class='address']").each do |address|
        address.xpath("./div").each do |div|
          div.remove
        end
        businessFound['listed_address'] = address.inner_text.strip
      end

      return businessFound
    end

    businessFound
  end

end
