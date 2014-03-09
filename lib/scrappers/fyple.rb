class Fyple < AbstractScrapper
  # http://www.fyple.com/search/ADT+Security+Services/Pleasanton+CA/
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://www.fyple.com/search/#{CGI.escape(@data['business'])}/#{CGI.escape(@data['city'])}+#{CGI.escape(@data['state_short'])}/"
    page = mechanize.get(url)

    page.search("div.title a span").each do |item|
      next unless match_name?(item, @data['business'])

      businessUrl = "http://www.fyple.com" + item.parent.attr("href").gsub("../../..", "")
      subpage = mechanize.get(businessUrl)

      # Sort by ZIP
      next unless subpage.search("div.address div").text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = subpage.search("div.phone span").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ subpage.search("div.address div br[1]")[0].previous,
                        subpage.search("div.address div br[1]")[0].next,
                        subpage.search("div.address div br[2]")[0].next]

      return {
        'status' => subpage.search("a.claim").length > 0 ? :listed : :claimed,
        'listed_name' => item.text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
