class Bing < AbstractScrapper
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
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

      businessUrl = item.search(".//h3/a")[0]['href']
      subpage = mechanize.get(businessUrl)

      # Additional sort by business name
      next unless match_name?(subpage.search('div.business_name h2'), @data['business'])

      # Sort by ZIP
      next unless subpage.search('span.business_address').text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = subpage.search('span.business_phone_number').text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      return {
        'status' => :listed,
        'listed_name' => subpage.search('div.business_name h2').text.strip,
        'listed_address' => subpage.search('span.business_address').text.strip,
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
