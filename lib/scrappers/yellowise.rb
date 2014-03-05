require 'awesome_print'

class Yellowise < AbstractScrapper
  # http://www.yellowise.com/results/Orange/Inkling%20Tattoo%20Gallery
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://www.yellowise.com/results/#{URI::encode(@data['city'])}/#{URI::encode(@data['business'].gsub("&", "and"))}"
    page = Nokogiri::HTML(RestClient.get(url))

    page.css("div.search-item").each do |item|
      next unless match_name?(item.xpath("./div/div[2]/div[1]/a"), @data['business'])

      address_parts = item.xpath(".//address/span")
      2.times {address_parts.pop}
      businessPhone = address_parts.pop.text.strip

      zip_presence = nil
      address_parts.each do |street_address|
        if street_address.text =~ /#{@data['zip']}/i
          zip_presence = true
        end
      end

      # Sort by ZIP
      next unless zip_presence

      # Sort by business phone number
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      return {
        'status' => item.xpath(".//img[@alt='Verified Business']")[0] ? :claimed : :listed,
        'listed_name' => item.xpath("./div/div[2]/div[1]/a").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => item.xpath("./div/div[2]/div[1]/a")[0].attr("href")
      }
    end

    return {'status' => :unlisted}
  end

end
