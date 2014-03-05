class Twitter < AbstractScrapper
  # http://twitter.com/search?mode=users&q=McDonald's
  # Request:
  # - Business name
  # Sort:
  # - Business name

  def execute
    url = "http://twitter.com/search?mode=users&q=" + URI::encode(@data['business'])
    page = mechanize.get(url)

    page.search("ol#stream-items-id li").each do |item|
      next unless match_name?(item.search(".//strong"), @data['business'])
      businessUrl = 'http://twitter.com' + item.search('.//a')[0]['href']
      subpage = mechanize.get(businessUrl)

      return {
        'status' => subpage.search('.verified-link').size > 0 ? :claimed : :listed,
        'listed_name' => item.search(".//strong").text.strip,
        'listed_address' => subpage.search('.location.profile-field').text.strip,
        'listed_phone' => '',
        'listed_url' => businessUrl
      }
    end

    return {'status' => :unlisted}
  end

end
