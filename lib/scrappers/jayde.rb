class Jayde < AbstractScrapper
  # http://www.jayde.com/sch.html?q=mcdonald%27s
  # Request:
  # - Business name
  # Sort:
  # - Business name

  def execute
    html = rest_client.get('http://jayde.com/sch.html?q=' + URI::encode(@data['business']))
    if html.include?('Sorry, no match found')
      return {'status' => :unlisted}
    end
    page_nok = Nokogiri::HTML(html)

    page_nok.search('.listing-info-box').each do |item|
      link = item.search('.listing-site-title')[0]
      next unless match_name?(link, @data['business'])
      
      return {
          'status' => :listed,
          'listed_name' => link.text.strip,
          'listed_url' => link['href'],
          'listed_phone' => '',
          'listed_address' => ''
      }
    end

    return {'status' => :unlisted}
  end

end