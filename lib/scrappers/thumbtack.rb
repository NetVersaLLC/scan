class Thumbtack < AbstractScrapper
  # http://www.thumbtack.com/ca/fullerton/carpet-cleaning/window-and-blind-cleaning
  # Bussiness name: Window & Blind Cleaning
  # Zip: 92832

  def execute
    businessFound = {'status' => :unlisted}

    url = "http://www.thumbtack.com/search?pagenum=1&keyword=#{CGI.escape(@data['business'])}&location=#{@data['zip']}"
    page = Nokogiri::HTML(RestClient.get(url))

    if page.at_xpath("//a[contains(text(), \"#{@data['business']}\")]") # Does a link of the business name exist?
      a = page.search("//a[contains(text(), \"#{@data['business']}\")]")
      businessFound['status'] = :claimed
      businessFound['listed_name'] = a.text.strip
      businessFound['listed_url'] = "http://www.thumbtack.com" + a.attr('href').value
      business_page = Nokogiri::HTML(RestClient.get(businessFound['listed_url']))

      businessFound['listed_address'] = business_page.search("//h4[text()='Location']")[0].next.next.text.strip
      businessFound['listed_address'].tr!('^ A-Za-z0-9\-,', ' ') # replacing invisible characters with spaces
    end
    businessFound
  end

end

http://www.thumbtack.com/search?pagenum=1&keyword=window-and-blind-cleaning&location=92832