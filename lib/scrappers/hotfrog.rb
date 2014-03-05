class Hotfrog < AbstractScrapper
  # http://www.hotfrog.com/Companies/Inkling-Tattoo-Gallery
  # Request:
  # - Business name
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    businessFixed = replace_char(@data['business'])
    url = "http://www.hotfrog.com/Companies/" + businessFixed

    begin
      page = Nokogiri::HTML(RestClient.get(url))

      if page.search('.company-contact-info')

        # Sort by ZIP
        unless page.search('.company-contact-info strong')[0].next.text =~ /#{@data['zip']}/i
          return {'status' => :unlisted}
        end

        # Sort by business phone number
        businessPhone = page.search('.company-contact-info strong')[1].next.text.strip
        if !@data['phone'].blank?
          unless  phone_form(@data['phone']) == phone_form(businessPhone)
            return {'status' => :unlisted}
          end
        end

        return {
          'status' => :listed,
          'listed_name' => page.search('.company-heading').text.strip,
          'listed_address' => page.search('.company-contact-info strong')[0].next.text.strip,
          'listed_phone' => businessPhone,
          'listed_url' => url
        }
      end
    rescue
      return {'status' => :unlisted}
    end

    return {'status' => :unlisted}
  end

  def replace_char(business)
    business.gsub(/\&|\,|\./, " ").strip.squeeze(" ").gsub(" ", "-").gsub("'", "")
  end

end
