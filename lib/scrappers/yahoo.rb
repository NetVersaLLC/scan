class Yahoo < AbstractScrapper
  # http://local.search.yahoo.com/search?p=Inkling Tattoo Gallery&addr=Orange, CA&fr2=sb-top&type_param=
  # Search by:
  # - Business name
  # - ZIP

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
      content.xpath("./h3").each do |h3|
        if h3.inner_text.strip =~ /#{@data['business']}/i
          h3.xpath("./div").each do |div|
            div.remove
          end
          businessFound['listed_name'] = h3.inner_text.strip

          h3.xpath("./a").each do |a|
            url = a.attr('href')
            if url =~ /(local.yahoo.com.*)/
              businessFound['listed_url'] = "http://#{$1}"
            end
          end

          businessFound['status'] = :listed
          content.xpath("./span[@class='merchant-ver']").each do |div|
            businessFound['status'] = :claimed
          end

          content.xpath("./div[@class='phone']").each do |phone|
            businessFound['listed_phone'] = phone.inner_text.strip
          end

          content.xpath("./div[@class='address']").each do |address|
            address.xpath("./div").each do |div|
              div.remove
            end
            businessFound['listed_address'] = address.inner_text.strip
          end
        end
      end
      break
    end

    businessFound
  end

end
