class Magicyellow < AbstractScrapper
	# http://www.magicyellow.com/add-your-business.cfm?step=2&phone=(714)+538-8748
  # Request:
  # - Business phone number
  # Sort:
  # - Business name
  # - ZIP

	def execute
		business_phone = phone_form(@data['phone'])

		business_phone =  "(" 								 + 
											business_phone[0..2] + 
											")"									 + 
											"+"									 + 
											business_phone[3..5] + 
											"-"									 + 
											business_phone[6..9]

		url = "http://www.magicyellow.com/add-your-business.cfm?step=2&phone=#{business_phone}"

		html = RestClient.get(url)
		page_nok = Nokogiri::HTML(html)

		if !page_nok.xpath("//td[@class='lAddress']")[0].blank?
			page_nok.xpath("//td[@class='lAddress']")[0].parent.parent.xpath("./tr").each do |item|
				next unless match_name?(item.search(".//b"), @data['business'])
				# Sort by ZIP
				next unless item.text =~ /#{@data['zip']}/i

				businessAddress = []
				item.search("./td[1]/*//td[@nowrap='nowrap']").each do |address_part|
					businessAddress << address_part.text.strip
				end

	      return {
      	  'status' => item.at_xpath(".//td[2]").content.include?('Already Claimed') ? :claimed : :listed,
    	    'listed_name' => item.search(".//b").text.strip,
  	      'listed_address' => businessAddress.join(", "),
	        'listed_phone' => business_phone.gsub("+", " "),
        	'listed_url' => url
      	}
			end
		end

	return {'status' => :unlisted}
	end

end
