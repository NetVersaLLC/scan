class Localpages < AbstractScrapper
  # http://www.localpages.com/CA/Compton/New-Life-Praise-Temple

  def execute
    businessfixed = @data['business'].gsub(" ", "-").gsub("'", "")
    cityfixed = @data['city'].gsub(" ", "-")
    url = "http://www.localpages.com/#{@data['state_short']}/#{cityfixed}/#{businessfixed}"

    businessFound = {'status' => :unlisted}

    begin
      page = mechanize.get(url)

      page.search("ul.fluid_results_list li").each do |item|
        next unless replace_char(item.search('.//h3').text) =~ /#{replace_char(@data['business'])}/i
        profile_url = item.search(".//a")[0]['href']
        profile_page = mechanize.get(profile_url)

        streetAddress = profile_page.search('span.address')[0].content.strip
        addressLocality = profile_page.search('span.city')[0].content.strip
        addressRegion = profile_page.search('span.state')[0].content.strip
        postalCode = profile_page.search('span.state')[0].next.content[2..6].strip

        businessFound['status'] = :claimed
        if profile_page.search(".//a").text =~ /Claim Your Business Listing/i
          businessFound['status'] = :listed
        end

        businessFound['listed_name'] = profile_page.search('.businessName')[0].content.strip
        businessFound['listed_address'] = [streetAddress, addressLocality, addressRegion, postalCode].join(", ")
        businessFound['listed_phone'] = profile_page.search('.phone_icon')[0].content.strip
        businessFound['listed_url'] = profile_url

        return businessFound
      end
    rescue
    end

    businessFound
  end

  def replace_char(business)
    business.gsub("&", "and").gsub("'", "")
  end

end




