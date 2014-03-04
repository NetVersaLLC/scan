require 'mechanize'
require 'rest-client'
require 'headless'

class AbstractScrapper
  def initialize(data)
    @data = data
  end

  def browser
    nil
  end

  def close_browser
    return if @watir.nil?
    @watir.close
    @watir = nil
  end

  def rest_client
    RestClient
  end

  def need_browser?
    false
  end

  def mechanize
    if @agent.nil?
      @agent = Mechanize.new
    end
    @agent
  end

  def watir
    if @watir.nil?
      # unfortunately phantomjs does not handle redirects well.
      # If it will change few versions later, headless may be removed
      # @watir = Watir::Browser.new :phantomjs
      if RUBY_PLATFORM =~ /linux/ then
        @headless = Headless.new(display: 100, reuse: true, destroy_at_exit: false).start
      end
      @watir = Watir::Browser.new
    end
    @watir
  end

  def phone_form(phone_number)
    res = ""
    phone = phone_number.gsub("+1", "")
    
    phone.each_char do |char|
      if char =~ /^[0-9]$/
        res += char
      end
    end

    if res.length == 10
      res
    else
      phone_number
    end
  end

  # tupalo.rb, foursquare.rb, cylex.rb
  def address_form(address_parts)
    businessAddress = []
    address_parts.each do |part|
      part = part.text.strip
      if !part.blank?
        businessAddress << part
      end
    end

    businessAddress.join(", ")
  end

end
