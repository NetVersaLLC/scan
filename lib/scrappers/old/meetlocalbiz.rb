class Meetlocalbiz < AbstractScrapper
  # http://tupalo.com/en/search?q=Inkling+Tattoo+Gallery&city_select=Orange%2C+CA
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

#data = {}
#data['business'] = "Klein, Emard and Rice"
#data['zip'] 	= "33606"



  def execute
		url = "http://www.meetlocalbiz.com/search/?search_keywords=#{CGI.escape(@data['business'])}&search_zip=#{@data['zip']}&mySubmit=+"
		businessFound = {}
		businessFound['status'] = :unlisted

		nok = Nokogiri::HTML(RestClient.get url)

		nok.css("div.companylisting").each do |listing|
			if listing.css("span.biz-name").text =~ /#{@data['business']}/i

				#ap listing.css("span.biz-name a").attr("href").text
				businessFound['listed_url'] = "www.meetlocalbiz.com"+ URI.escape(listing.css("span.biz-name a").attr("href").text)
				subpage = Nokogiri::HTML(RestClient.get businessFound['listed_url'])
				ap subpage.css("p.address").text.delete("[google maps]")
				businessFound['listed_address']		= subpage.css("p.address").text.gsub(/\n+|\t+/, "").squeeze(" ").strip.gsub("[google maps]","")
				businessFound['listed_phone']		= subpage.css("p.phone").text.gsub("Ph: ","")
				businessFound['listed_name']		= subpage.css("p.boxtitle").text
				businessFound['status']				= :claimed


				break
			end
		end

		[true, businessFound]
	end

end
