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
    puts "closing browser"
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
end