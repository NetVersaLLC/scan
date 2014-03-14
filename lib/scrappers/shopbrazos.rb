class Shopbrazos < AbstractScrapper
  # http://www.theeagle.com/shopbrazos/?keyword=Inkling+Tattoo+Gallery&areaSelect=92869&radius=50&zipcode=92869&limit=50&sort=geodist&advancedFormStateNEW=off&cityName=&action=srch
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

  def execute
    url = "http://www.theeagle.com/shopbrazos/?keyword=#{CGI.escape(@data['business'])}&areaSelect=#{@data['zip']}&radius=50&zipcode=#{@data['zip']}&limit=50&sort=geodist&advancedFormStateNEW=off&cityName=&action=srch"
    page = Nokogiri::HTML(RestClient.get(url))

    page.css("ul.description li").each do |item|
      next unless match_name?(item.css("h4 a"), @data['business'])

      # Sort by ZIP
      next unless item.css("span.zip").text =~ /#{@data['zip']}/i

      # Sort by business phone number
      businessPhone = item.css("p.tel").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      address_parts = [ item.css("span.street br")[0].previous,
                        item.css("span.city"),
                        item.css("span.state"),
                        item.css("span.zip")]

      return {
        'status' => :listed,
        'listed_name' => item.css("h4 a").text.strip,
        'listed_address' => address_form(address_parts),
        'listed_phone' => businessPhone,
        'listed_url' => "http://www.theeagle.com" + item.css("h4 a")[0].attr("href")
      }
    end

    return {'status' => :unlisted}
  end

end



=begin
@browser.goto('http://www.shopbrazos.com/')

@browser.text_field( :id => 'project').set data['business']
@browser.text_field( :id => 'searchCity').set data['business']
@browser.button( :name => 'frmSubmit').click

sleep(3)
Watir::Wait.until { @browser.h2(:text => 'SEARCH RESULTS') }

if @browser.text.include? "There are no listings located for"
  businessFound = [:unlisted]
else
  if @browser.link(:text => /#{data['business']}/).exists?
    @browser.link(:text => /#{data['business']}/).click
    Watir::Wait.until { @browser.div( :class => 'ListingsPageBusinessBlock').exists? }
    if @browser.link(:title => 'Claim  | Shop Brazos').exists?
      businessFound = [:listed, :unclaimed]
    else
      businessFound = [:listed, :claimed]
    end
    
  else
    businessFound = [:unlisted]
  end
  
end

[true,businessFound]
=end