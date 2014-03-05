class Facebook < AbstractScrapper
  # https://www.facebook.com/search.php?q=Inkling+Tattoo+Gallery
  # Request:
  # - Business name
  # Sort:
  # - Business name
  # - ZIP

  def execute
    url = "https://www.facebook.com/search.php?q=#{CGI.escape(@data['business'])}"
    page = mechanize.get(url)

    if page.search("div#pagelet_search_no_results").blank?
      page.search("div.detailedsearch_result").each do |item|
        next unless match_name?(item.search("div.instant_search_title a"), @data['business'])
        # Skip a personal page
        next unless item.search("div.fbProfileByline").blank?
        # Sort by ZIP
        next unless item.search("div.fsm.fwn.fcg div.fsm.fwn.fcg")[0].text =~ /#{@data['zip']}/i

        return {
          'status' => item.search('._56_f').size > 0 ? :claimed : :listed,
          'listed_name' =>item.search("div.instant_search_title a").text.strip,
          'listed_address' => item.search("div.fsm.fwn.fcg div.fsm.fwn.fcg")[0].text.inspect.gsub(' \u00B7 ', ", ").gsub("\"", ""),
          'listed_url' => item.search("div.instant_search_title a")[0]['href']
        }
      end
    end

    return {'status' => :unlisted}
  end

end
