require 'awesome_print'

class Mycitybusiness < AbstractScrapper

  def execute
    businessFound = {'status' => :unlisted}
    html = RestClient.post('http://www.mycitybusiness.net/search.php', {:kword => @data['business'], :city => @data['city'], :state => @data['state_short']})
    page = Nokogiri::HTML(html)
    page.xpath("//strong[contains(text(), 'Company / Address')]").each do |top|
      tbody = top.parent.parent.parent
      tbody.children.each do |tr|
        next unless tr.xpath("./td[2]").text.tr('^0-9', '').include?(@data['phone'].tr('^0-9', ''))
        businessFound['status'] = :claimed
        businessFound['listed_name'] = tr.previous.text.strip
        businessFound['listed_address'] = tr.xpath("./td[1]//td[1]").text.strip + "," + tr.xpath("./td[1]//td[2]").text.strip
        businessFound['listed_phone'] = tr.xpath("./td[2]").text.strip
        if tr.at("./td[3]//td[2]//a")
          businessFound['listed_url'] = tr.xpath("./td[3]//td[2]//a").attr('href').value
        end
        return businessFound
      end
    end
    businessFound
  end

end


