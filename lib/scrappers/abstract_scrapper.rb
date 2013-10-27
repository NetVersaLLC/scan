require 'mechanize'
require 'rest-client'

class AbstractScrapper
  def initialize(data)
    @data = data
  end

  def browser
    nil
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
      @watir = Watir::Browser.new :phantomjs
    end
    @watir
  end
end