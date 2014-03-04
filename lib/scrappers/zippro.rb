require 'awesome_print'

class Zippro < AbstractScrapper
  # http://94706.zip.pro/Jodie%27s%20Restaurant
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://#{URI::encode(@data['zip'])}.zip.pro/#{URI::encode(@data['business'])}"
    page = mechanize.get(url)

    page.search("li a.result-title").each do |item|
      next unless item.text =~ /#{@data['business']}/i

      businessUrl = item.attr("href")
      subpage = mechanize.get(businessUrl)

      # Sort by ZIP
      next unless subpage.search("span[@itemprop='postal-code']").text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = subpage.search("span[@itemprop='tel']").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ subpage.search("span[@itemprop='street-address']"),
                        subpage.search("span[@itemprop='locality']"),
                        subpage.search("span[@itemprop='region']"),
                        subpage.search("span[@itemprop='postal-code']")]

      return {
        'status' => :listed,
        'listed_name' => item.text.strip,
        'listed_address' => address_form(address_parts).gsub(",,", ","),
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
