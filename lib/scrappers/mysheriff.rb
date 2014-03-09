class Mysheriff < AbstractScrapper
  # http://www.mysheriff.net/search/?business=&sheriffcode=Green+Pea+Salon&location=
  # Request:
  # - Business name
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://www.mysheriff.net/search/?business=&sheriffcode=#{CGI.escape(@data['business'])}&location="
    page = mechanize.get(url)

    page.search("div.listing div[1]").each do |item|
      next unless match_name?(item.search("span a"), @data['business'])

      businessUrl = item.search("span a")[0].attr("href")
      subpage = mechanize.get(businessUrl)

      # Sort by ZIP
      businessAddress = subpage.search("div#summary div div p br")[0].previous.text.gsub(/\t+|\n+/, '').strip
      next unless businessAddress =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = subpage.search("ul.verticaladdess li b").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      return {
        'status' => subpage.search("span.error").length > 0 ? :claimed : :listed,
        'listed_name' => item.search("span a").text.strip,
        'listed_address' => businessAddress,
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
