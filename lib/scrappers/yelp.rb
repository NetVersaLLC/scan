require 'awesome_print'

class Yelp < AbstractScrapper
  # http://www.yelp.com/search?find_desc=Inkling+Tattoo+Gallery&find_loc=92869
  # Search by:
  # - Business name
  # - ZIP

  def execute
    url = 'http://www.yelp.com/search?find_desc=' + URI::encode(@data['business']) + '&find_loc=' + URI::encode(@data['zip'])
    page = mechanize.get(url)
    
    page.search("h3.search-result-title span a.biz-name").each do |item|
      next unless item.text.gsub(/\W/,"") =~ /#{@data['business'].gsub(/\W/,"")}/i

      businessUrl = 'http://www.yelp.com' + item.attr("href")
      subpage = mechanize.get(businessUrl)

      address_parts = [ subpage.search("span[@itemprop='streetAddress']"),
                        subpage.search("span[@itemprop='addressLocality']"),
                        subpage.search("span[@itemprop='addressRegion']"),
                        subpage.search("span[@itemprop='postalCode']")]

      return {
        'status' => :listed,
        'listed_name' => item.text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => subpage.search("span[@itemprop='telephone']").text.strip,
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
