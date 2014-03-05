class Localpages < AbstractScrapper
  # http://www.localpages.com/CA/Compton/New-Life-Praise-Temple
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    businessfixed = @data['business'].gsub(" ", "-").gsub("'", "")
    cityfixed = @data['city'].gsub(" ", "-")
    url = "http://www.localpages.com/#{@data['state_short']}/#{cityfixed}/#{businessfixed}"

    begin
      page = mechanize.get(url)

      page.search("ul.fluid_results_list li").each do |item|
        next unless replace_char(item.search('.//h3').text.strip.downcase) == replace_char(@data['business']).downcase

        # Sort by ZIP
        next unless item.search(".//p")[0].text =~ /#{@data['zip']}/i

        # Sort by business phone number
        businessPhone =  item.search(".//span[@class='result_phone']").text.strip
        if !@data['phone'].blank?
          next unless  phone_form(@data['phone']) == phone_form(businessPhone)
        end

        return {
          'status' => :listed,
          'listed_name' => item.search('.//h3').text.strip,
          'listed_address' => item.search(".//p")[0].text.strip,
          'listed_phone' => businessPhone,
          'listed_url' => item.search(".//a")[0]['href']
        }
      end
    rescue
      return {'status' => :unlisted}
    end

    return {'status' => :unlisted}
  end

  def replace_char(business)
    business.gsub("&", "and").gsub("'", "")
  end

end
