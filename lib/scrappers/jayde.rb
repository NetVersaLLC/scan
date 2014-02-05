class Jayde < AbstractScrapper
  # http://www.jayde.com/sch.html?q=mcdonald%27s

  def execute
    page_html = rest_client.get('http://jayde.com/sch.html?q=' + URI::encode(@data['business']))
    if page_html.include?('Sorry, no match found')
      return {'status' => :unlisted}
    end
    page_nok = Nokogiri::HTML(page_html)

    page_nok.search('.listing-info-box').each do |item|
      link = item.search('.listing-site-title')[0]
      next unless link.text.downcase.strip.include?(@data['business'].downcase.strip)
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