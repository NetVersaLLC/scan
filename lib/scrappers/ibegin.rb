class Ibegin < AbstractScrapper

  def execute
    @use_proxy = true

    url = "http://www.ibegin.com/search/phone/?phone=#{CGI.escape(@data['phone'])}"
    # puts(url)
    page = Nokogiri::HTML(rest_client.get(url))

    businessFound = {}
    unless page.css("div.business").length == 0
      link = page.css("div.business a")
      link = "http://www.ibegin.com" + link[0]["href"]
      businessFound['listed_url'] = link
      subpage = Nokogiri::HTML(rest_client.get(link))
      subpage.css("p.bizContactDetails").each do |p|
        contact_details = p.inner_text.to_s
        if contact_details =~ /(\(\d\d\d\) \d\d\d-\d\d\d\d)/
          phone = $1
          contact_details.gsub!(phone, '').strip
          phone.gsub!(/[()]/, '')
          phone.gsub!(/ /, '-')
          businessFound['listed_phone'] = phone
        end
        businessFound['listed_address'] = contact_details
      end
      businessFound['listed_name'] = subpage.css(".bizTitle").inner_text.to_s
      claimLink = subpage.css("li#axNavClaimit a")
      if claimLink.length == 0
        businessFound['status'] = :claimed
      else
        businessFound['status'] = :listed
      end
      unless businessFound.has_key?('listed_phone')
        # ibegin pages broken sometimes. Business considered as unlisted for such cases
        businessFound['status'] = :unlisted
      end
    else
      businessFound['status'] = :unlisted
    end
    businessFound
  end
end