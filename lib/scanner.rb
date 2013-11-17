require 'net/http'
require 'uri'
require 'watir-webdriver'
require 'rest_client'
require 'nokogiri'
require 'mechanize'
require 'lib/proxy'
require 'lib/payload'
require 'lib/scrappers/abstract_scrapper.rb'

class Scanner

  attr_accessor :scrapper

  def initialize(site, data, callback_host, callback_port)
    @data = data
    @site = site
    @scrapper = get_scrapper
    @callback_host = callback_host
    @callback_port = callback_port
    #todo: move scrapper object init here
  end

  def http_client=(client)
    @http_client = client
  end


  def http_client
    if @http_client.nil?
      @http_client = Net::HTTP.new(@callback_host, @callback_port)
      if @callback_port.to_i == 443
        @http_client.use_ssl = true
        @http_client.ca_file = File.dirname(__FILE__) + '/ca-bundle.crt'
        @http_client.verify_mode = OpenSSL::SSL::VERIFY_PEER
        #@http_client.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
    end
    @http_client
  end

  def stringify_values(h)
    h.each do |key,value|
      h[key] = value.is_a?(Hash) ? stringify_values(value) : value.to_s
    end
    h
  end

  def make_callback(response)
    begin
      http_client.post('/scanapi/submit_scan_result', Rack::Utils.build_nested_query(stringify_values(response)))
    rescue => e
      raise 'Scan server callback failed: ' + e.to_s
    end
  end

  def scan(skip_callback = false)
    RestClient.proxy = nil
    begin
      result = @scrapper.execute
    rescue => e
      result = {
          :error_message => "Scan failed for #{@site}: #{e}: #{e.backtrace.join("\n")}"
      }
    end
    @scrapper.close_browser # kill firefox instance if exists
    result[:id] = @data['id']
    response = {
        :scan => result,
        :token => $settings['callback_auth_token']
    }
    make_callback(response) unless skip_callback
    response
  end

  def close_browser
  end

  def get_scrapper
    begin
      require 'lib/scrappers/' + @site.downcase + '.rb'
      return Object.const_get(@site).new(@data)
    rescue LoadError
      return Payload.new(@site, @data)
    end
  end
end