class Hotfrog < AbstractScrapper
  # http://www.hotfrog.com/Companies/Inkling-Tattoo-Gallery
  # Search by:
  # - Business name

  def execute
    businessFound = {'status' => :unlisted}

    businessFixed = replace_char(@data['business'])
    profile_url = "http://www.hotfrog.com/Companies/" + businessFixed

    begin
      profile_page = Nokogiri::HTML(RestClient.get(profile_url))

      if profile_page.search('.company-contact-info')
        fullAddress = profile_page.search('.company-contact-info strong')[0].next.content.strip.split(", ")
        streetAddress = fullAddress[0]
        addressLocality = fullAddress[1]
        stateAndPostalCode = fullAddress[2].gsub(" ", ", ")

        businessFound['status'] = :listed
        businessFound['listed_name'] = profile_page.search('.company-heading')[0].content.strip
        businessFound['listed_address'] = [streetAddress, addressLocality, stateAndPostalCode].join(", ")
        businessFound['listed_phone'] = profile_page.search('.company-contact-info strong')[1].next.content.strip
        businessFound['listed_url'] = profile_url
      end
    rescue
    end

    businessFound
  end

  def replace_char(business)
    business.gsub(/\&|\,|\./, " ").strip.squeeze(" ").gsub(" ", "-").gsub("'", "")
  end

end


