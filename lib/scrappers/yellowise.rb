require 'awesome_print'

class Yellowise < AbstractScrapper
  # http://www.yellowise.com/results/Orange/Inkling%20Tattoo%20Gallery

  def execute
    businessFound = {'status' => :unlisted}

    url = "http://www.yellowise.com/results/#{URI::encode(@data['county'])}/#{URI::encode(@data['business'])}"

    page = Nokogiri::HTML(RestClient.get(url))
    thelist = page.css("div#block-block-25")

    unless thelist.css("div.search-item").length == 0
      thelist.css("div.search-item").each do |item|
        if item.search(".//a").text =~ /#{@data['business']}/i
          link = item.search(".//a[contains(text(), \"#{@data['business']}\")]")
          if item.at_xpath(".//img[@alt='Verified Business']")
            businessFound['status'] = :claimed
          else
            businessFound['status'] = :listed
          end
          businessFound['listed_url'] = link.attribute('href').value
          businessFound['listed_name'] = link.text.strip
          businessFound['listed_address'] = item.search(".//address/span[1]").text + ", " + item.search(".//address/span[2]").text.gsub(/,/, '').split.join(", ")
          businessFound['listed_address'].strip!
          businessFound['listed_phone'] = item.search(".//address/span[3]").text.strip

        end
      end
    end
    businessFound
  end

end


