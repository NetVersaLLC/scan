class Yellowassistance < AbstractScrapper
  # http://www.yellowassistance.com/frmBusResults.aspx?nas=a&nam=Signal+Lounge&cas=r&cat=Signal+Lounge&mis=a&mil=&zis=a&zip=92869&cis=r&cit=Orange&sts=r&sta=CA&typ=bus&set=a&myl=&slat=&slon=
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://www.yellowassistance.com/frmBusResults.aspx?nas=a&nam=#{CGI.escape(@data['business'])}&cas=r&cat=#{CGI.escape(@data['business'])}&mis=a&mil=&zis=a&zip=#{@data['zip']}&cis=r&cit=#{CGI.escape(@data['city'])}&sts=r&sta=#{@data['state_short']}&typ=bus&set=a&myl=&slat=&slon="
    page = Nokogiri::HTML(RestClient.get(url))

    page.css(".Verdana12 a strong").each do |item|
      next unless match_name?(item, @data['business'])

      businessUrl = item
      5.times do 
        businessUrl = businessUrl.parent
        businessUrl.css("a").blank? ? next : break
      end

      businessUrl = "http://www.yellowassistance.com/" + businessUrl.css("a")[0].attr("href")
      subpage = Nokogiri::HTML(RestClient.get(businessUrl))  

      # Sort by ZIP
      next unless subpage.css("span#lblAddress br")[0].next.text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = subpage.css("span#lblPhone").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ subpage.css("span#lblAddress br")[0].previous,
                        subpage.css("span#lblAddress br")[0].next]

      return {
        'status' => subpage.css("a#lnkListing").blank? ? :claimed : :listed,
        'listed_name' => item.text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
