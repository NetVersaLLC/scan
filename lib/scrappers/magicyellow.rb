class Magicyellow < AbstractScrapper
	# http://www.magicyellow.com/add-your-business.cfm?step=2&phone=(714)+538-8748
  # Search by:
  # - Business name
  # - Business phone number

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
				next unless item.search(".//b").text =~ /#{@data['business']}/i

				address_path = item.search("./td[1]/*")
    	  streetAddress = address_path.xpath("./tr[2]/td").text.strip
		    regionAddress = address_path.xpath("./tr[3]/td").text.strip

	      return {
      	  'status' => item.at_xpath(".//td[2]").content.include?('Already Claimed') ? :claimed : :listed,
    	    'listed_name' => item.search(".//b").text.strip,
  	      'listed_address' => [streetAddress, regionAddress].join(", "),
	        'listed_phone' => @data['phone'],
        	'listed_url' => url
      	}
			end
		end

	return {'status' => :unlisted}
	end

end
