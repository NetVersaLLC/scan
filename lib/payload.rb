require 'watir-webdriver'
require 'rest_client'
require 'nokogiri'
require 'mechanize'
require 'lib/proxy'

class Payload
  attr_accessor :browser

  def initialize(site, data)
    @data = data
    @chained = true
    @code = File.read(File.dirname(File.dirname(__FILE__)) + '/lib/scrappers/old/' + site.downcase + '.rb')
    if @code.include?('@browser')
      @browser = Watir::Browser.new :phantomjs
    end
  end

  def data
    @data
  end

  def execute
    ret, result = eval(@code, get_binding)
    unless ret
      raise 'Job failed'
    end
    unless @browser.nil?
      @browser.close
      @browser = nil
    end
    result
  end

  # returns binding object for eval() method
  def get_binding
    binding()
  end
end