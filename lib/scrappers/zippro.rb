require 'awesome_print'

class Zippro < AbstractScrapper
  # http://92869.zip.pro/Inkling+Tattoo+Gallery
  
  def execute
    result = {'status' => :unlisted}

    url = "http://#{URI::encode(@data['zip'])}.zip.pro/#{URI::encode(@data['business'])}"
    page = mechanize.get(url)
    thelist = page.search('li div.resultList')

    unless thelist.size == 0
      if thelist.first.search(".//a[@class='result-title']").text =~ /#{@data['business']}/i
        profile_url = thelist.first.search(".//a[@class='result-title']").attribute('href').value
        profile_page = mechanize.get(profile_url)

        streetAddress = profile_page.search('span[@itemprop="street-address"]')[0].content
        addressLocality = profile_page.search('span[@itemprop="locality"]')[0].content
        addressRegion = profile_page.search('span[@itemprop="region"]')[0].content.gsub(" ", ", ")
        postalCode = profile_page.search('span[@itemprop="postal-code"]')[0].content

        result = {
            'status' => :listed,
            'listed_name' => profile_page.search('span[@itemprop="name"]')[0].content.strip,
            'listed_address' => [streetAddress, addressLocality, addressRegion, postalCode].join(),
            'listed_phone' => profile_page.search('span[@itemprop="tel"]')[0].content,
            'listed_url' => profile_url
        }
      end
    end
    result
  end

end
