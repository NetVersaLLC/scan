class Mycitybusiness < AbstractScrapper
  # http://www.mycitybusiness.net/search.php plus parametres for POST HTTP request

  def execute
    businessFound = {'status' => :unlisted}
    html = RestClient.post('http://www.mycitybusiness.net/search.php', {:kword => @data['business'], :city => @data['city'], :state => @data['state_short']})
    page = Nokogiri::HTML(html)

    count = page.xpath("//td//b[contains(text(), 'Results')]").text.split(" ")[0].to_i
    unless count == 0
      list_start = page.xpath("//strong[contains(text(), 'Company / Address')]")[0]
      tbody = list_start.parent.parent.parent

      streetAddress = tbody.xpath("./tr[3]/td[1]/*/tr[1]/td[1]").text.strip
      addressRegion = tbody.xpath("./tr[3]/td[1]/*/tr[2]/td[1]").text.strip.gsub(",", "").split(" ").join(", ")

      businessFound['status'] = :listed
      businessFound['listed_name']  = tbody.xpath("./tr[2]//strong").text.strip
      businessFound['listed_address'] = [streetAddress, addressRegion].join(", ")
      businessFound['listed_phone'] = tbody.xpath("./tr[3]/td[2]").text.strip
      unless tbody.xpath("./tr[3]/td[3]/*/tr[2]/td[1]/a").text.blank?
        businessFound['listed_url'] = tbody.xpath("./tr[3]/td[3]/*/tr[2]/td[1]/a").attribute('href').value
      end
    end

    businessFound
  end

end
