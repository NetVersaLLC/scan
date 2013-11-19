class Bing < AbstractScrapper

  # phone number is enough to identify business
  def execute
    html = rest_client.get "https://www.bingplaces.com/DashBoard"

    nok = Nokogiri::HTML(html)
    my_token = nil
    trace_id = nil
    nok.xpath("//input[@name='__RequestVerificationToken']").each do |token|
      my_token = token.attr('value')
    end

    nok.xpath("//input[@name='TraceId']").each do |token|
      trace_id = token.attr('value')
    end

    headers = html.headers
    cookie = headers[:set_cookie]

    sessId = cookie[0].split(";")[0]
    reqTok = cookie[3].split(";")[0]
    culture = cookie[2].split(";")[0]
    theCookie = culture + "; " + reqTok + "; " + sessId


    url = 'https://www.bingplaces.com/DashBoard/PerformSearch'

    params = {
        '__RequestVerificationToken' => my_token,
        'TraceId' => trace_id,
        'Market' => 'en-US',
        'PhoneNumber' => @data['phone'],
        'BusinessName' => '',
        'City' => '',
        'SearchCond' => 'SearchByCountryAndPhoneNumber',
        'ApplicationContextId' => 'undefined'
    }

    rheaders = {
        'Accept' => "*/*",
        "Accept-Encoding" => "gzip,deflate,sdch",
        "Accept-Language" => "en-US,en;q=0.8",
        "Connection" => "keep-alive",
        "Content-Length" => "337",
        "Content-Type" => "application/x-www-form-urlencoded; charset=UTF-8",
        "Cookie" => theCookie,
        "Host" => "www.bingplaces.com",
        "Origin" => "https://www.bingplaces.com",
        "Referer" => "https://www.bingplaces.com/DashBoard",
        "User-Agent" => "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.72 Safari/537.36",
        "X-Requested-With" => "XMLHttpRequest"
    }

    response = RestClient.post url, params, rheaders

    resNok = Nokogiri::HTML(response)

    result = {}
    result['status'] = :unlisted

    business_name = @data['business'].gsub('"', %q(\\\"))
    node = resNok.xpath('//a[@title="' + business_name + '"]')
    if node.to_s.size > 0

      result['listed_url'] = node.attr("href").text
      result['listed_phone'] = @data['phone']
      result['listed_name'] = node.text

      listPage = rest_client.get node.attr("href").text
      listNok = Nokogiri::HTML(listPage)

      result['listed_address'] = listNok.css("span.business_address")[0].text

      if resNok.css('a[@value="Select"]')
        result['status'] = :listed
      else
        result['status'] = :claimed
      end

    end
    result
  end
end