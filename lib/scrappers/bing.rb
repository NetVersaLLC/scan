class Bing < AbstractScrapper

  def execute
    businessFound = {'status' => :unlisted}

    agent = Mechanize.new
    page = agent.get("https://www.bing.com")

    agent.page.forms[0]["q"] = "#{@data['business']} #{@data['zip']} #{@data['city']} bingplaces"
    agent.page.forms[0]["qs"] = "ds"
    agent.page.forms[0]["form"] = "QBLH"
    search_list = agent.page.forms[0].submit

    content_key = "bing.com/local/Details.aspx"

    search_list.search("div#results ul li").each do |item|
        next unless item.search(".//cite").text =~ /#{content_key}/i
        next unless item.search(".//p[contains(text(), \"#{@data['business']}\")]")

        profile_url = item.search(".//h3/a")[0]['href']
        profile_page = mechanize.get(profile_url)

        fullAddress = profile_page.search('span.business_address')[0].content.strip.split(", ")
        streetAddress = fullAddress[0]
        addressLocality = fullAddress[1]
        stateAndPostalCode = fullAddress[2].gsub(" ", ", ")

        businessFound['status'] = :listed
        businessFound['listed_name'] = profile_page.search('div.business_name h2')[0].content.strip
        businessFound['listed_address'] = [streetAddress, addressLocality, stateAndPostalCode].join(", ")
        businessFound['listed_phone'] = profile_page.search('span.business_phone_number')[0].content.strip
        businessFound['listed_url'] = profile_url

        return businessFound
    end

    businessFound
  end

end
