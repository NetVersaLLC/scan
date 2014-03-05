class Mycitybusiness < AbstractScrapper
  # http://www.mycitybusiness.net/search.php plus parametres for POST HTTP request
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = 'http://www.mycitybusiness.net/search.php'
    html = RestClient.post(url, {:kword => @data['business'], 
                                 :city  => @data['city'], 
                                 :state => @data['state_short']
                                }
                          )
    page = Nokogiri::HTML(html)

    if page.xpath("//td//b[contains(text(), 'Results')]").text.split(" ")[0].to_i != 0
      list_start = page.xpath("//strong[contains(text(), 'Company / Address')]")[0]
      tbody = list_start.parent.parent.parent

      tbody.xpath(".//strong").each do |item|
        next unless match_name?(item, @data['business'])
        tr = item.parent.parent.next

        address_parts = tr.xpath("./td[1]/*/tr")
        address_parts.pop

        zip_presence = nil
        address_parts.each do |street_address|
          if street_address.text =~ /#{@data['zip']}/i
            zip_presence = true
          end
        end

        # Sort by ZIP
        next unless zip_presence

        # Sort by business phone number
        businessPhone = tr.xpath("./td[2]").text.strip
        if !@data['phone'].blank?
          next unless  phone_form(@data['phone']) == phone_form(businessPhone)
        end

        return {
          'status' => :listed,
          'listed_name' => item.text.strip,
          'listed_address' => address_form(address_parts),
          'listed_phone' => businessPhone,
          'listed_url' => ''
        }
      end
    end

    return {'status' => :unlisted}
  end

end
