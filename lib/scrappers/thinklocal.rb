class Thinklocal < AbstractScrapper
  # http://www.thinklocal.com/Search.aspx?keyword=Locksmith+Placentia&where=92870&type=Business%20Name
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://www.thinklocal.com/Search.aspx?keyword=#{CGI.escape(@data['business'])}&where=#{@data['zip']}&type=Business+Name"
    page = Nokogiri::HTML(RestClient.get(url))

    page.css("table[@width='100%'] td[2].finep").each do |item|
      next unless match_name?(item.css("strong a"), @data['business'])

      # Sort by ZIP
      next unless item.css("br")[1].next.text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = item.parent.css("td[3] br")[0].previous.text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ item.css("br")[0].next,
                        item.css("br")[1].next]

      return {
        'status' => :listed,
        'listed_name' => item.css("strong a").text.strip,
        'listed_address' => address_form(address_parts).gsub(",,", ","),
        'listed_phone' => businessPhone,
        'listed_url' => "http://www.thinklocal.com/" + item.css("strong a")[0].attr("href")
      }
    end

    return {'status' => :unlisted}
  end

end
