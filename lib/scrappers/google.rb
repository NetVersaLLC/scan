class Google < AbstractScrapper
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    api_key = 'AIzaSyCBULo3dEbDt8B1rIG4bKgzkUNx5_ubgs4'

    latlon = "#{@data['latitude']},#{@data['longitude']}"
    url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{latlon}&radius=50000&keyword=#{CGI.escape(@data['business'])}&sensor=false&key=#{api_key}"

    json_page = RestClient.get(url)
    general_page = JSON.parse(json_page)

    if general_page['results'] and general_page['results'].length > 0
      general_page['results'].each do |result|
        next unless replace_and(result['name']) =~ /#{replace_and(@data['business'])}/i

        json_page = RestClient.get "https://maps.googleapis.com/maps/api/place/details/json?reference=#{result['reference']}&sensor=true&key=#{api_key}"
        detail_page = JSON.parse(json_page)

        businessAddress = detail_page['result']['formatted_address']
        
        # Sort by ZIP
        businessZip = ""
        detail_page['result']['address_components'].each do |address_component|
          if address_component['types'].include?("postal_code")
            businessZip = address_component['long_name']
            businessAddress += ", " + businessZip
          end
        end
        next unless businessZip == @data['zip']

        # Sort by business phone number
        businessPhone = detail_page['result']['formatted_phone_number']
        if !@data['phone'].blank?
          next unless  phone_form(@data['phone']) == phone_form(businessPhone)
        end

        return {
          'status' => :listed,
          'listed_name' => result['name'],
          'listed_address' => businessAddress,
          'listed_phone' => businessPhone,
          'listed_url' => detail_page['result']['url']
        }
      end
    end

    return {'status' => :unlisted}
  end

  # replace '&' with 'and'
  def replace_and(business)
    return business.gsub("&","and")
  end

end
