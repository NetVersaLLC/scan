require 'watir-webdriver'
require 'rest_client'
require 'nokogiri'
require 'mechanize'
require 'lib/proxy'

class Scanner
  attr_accessor :browser, :data

  def initialize(site, data)
    @browser = Watir::Browser.new
    @data = data
    @site = site
    @chained = true
  end

  def data
    @data
  end

  def browser
    @browser
  end

  def scan
    RestClient.proxy = nil
    begin
      ret, result = eval(get_payload, get_binding)
      if ret == true
        response = {:error => nil, :result => result}
      elsif ret == false
        response = {:error => 'Job failed', :result => result}
      else
        response = {:error => nil, :result => result}
      end
    rescue => e
      response = {:error => "#{e}: #{e.backtrace.join("\n")}".to_json}
    end
    browser.close
    response
  end

  def get_payload
    parts = __FILE__.split('/')
    2.times { parts.pop }
    parts.push 'sites', @site, 'SearchListing', 'client_script.rb'
    File.open(parts.join('/'), 'r').read
  end


  # returns binding object for eval() method
  def get_binding
    return binding()
  end
end