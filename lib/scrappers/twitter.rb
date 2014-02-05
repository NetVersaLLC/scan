class Twitter < AbstractScrapper
  # https://twitter.com/McDonald's
  # Search by:
  # - Business name

  def execute
    businessFound = {'status' => :unlisted}
    url = "http://twitter.com/search?mode=users&q=" + URI::encode(@data['business'])
    page = mechanize.get(url)

    page.search("ol#stream-items-id li").each do |item|
      next unless item.search(".//strong").text =~ /#{@data['business']}/i
      profile_url = 'http://twitter.com' + item.search('.//a')[0]['href']
      profile_page = mechanize.get(profile_url)

      businessFound = {
          'status' => profile_page.search('.verified-link').size > 0 ? :claimed : :listed,
          'listed_name' => profile_page.search('.fullname span')[0].content,
          'listed_address' => profile_page.search('.location.profile-field')[0].content.strip,
          'listed_phone' => '',
          'listed_url' => profile_url
      }

      return businessFound
    end

    businessFound
  end
end