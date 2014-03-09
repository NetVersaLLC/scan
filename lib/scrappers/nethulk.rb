class Nethulk < AbstractScrapper
  # http://www.nethulk.com/search_list.php?s=Signal+Lounge&submit=Search&st=CA&zi=92869
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://www.nethulk.com/search_list.php?s=#{CGI.escape(@data['business'])}&submit=Search&st=#{@data['state_short']}&zi=#{@data['zip']}"
    page = Nokogiri::HTML(RestClient.get(url))

    page.xpath("//tr/td/div[3]/div/p").each do |item|
      next unless match_name?(item.xpath("./a[1]"), @data['business'])

      businessUrl = "www.nethulk.com" + item.xpath("./a[1]")[0].attr("href")


      # Sort by ZIP
      next unless item.xpath("./a[4]").text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = item.xpath("./a[5]").text.strip + 
                      item.xpath("./a[5]")[0].next.text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ item.xpath("./a[1]")[0].next.next,
                        item.xpath("./a[2]"),
                        item.xpath("./a[3]"),
                        item.xpath("./a[4]")]

      return {
        'status' => :listed,
        'listed_name' => item.xpath("./a[1]").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
