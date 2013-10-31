require 'awesome_print'

class Yellowise < AbstractScrapper

  def execute
    businessFound = {'status' => :unlisted}

    url = "http://www.yellowise.com/results/#{URI::encode(@data['zip'])}/#{URI::encode(@data['business'])}"

    page = Nokogiri::HTML(RestClient.get(url))
    thelist = page.css("div#block-block-25")

    unless thelist.css("div.search-item").length == 0
      thelist.css("div.search-item").each do |item|
        if item.search(".//a").text =~ /#{@data['business']}/i
          if item.at_xpath(".//img[@alt='Verified Business']")
            link = item.search(".//a[5]")
            businessFound['status'] = :claimed
          else
            link = item.search(".//a[4]")
            businessFound['status'] = :listed
          end
          businessFound['listed_url'] = link.attr('href').value
          businessFound['listed_name'] = link.text.strip
          businessFound['listed_address'] = item.search(".//address/span[1]").text + item.search(".//address/span[2]").text
          businessFound['listed_address'].strip!
          businessFound['listed_phone'] = item.search(".//address/span[3]").text.strip

        end
      end
    end
    businessFound
  end

end


