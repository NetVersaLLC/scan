require 'watir-webdriver'
require 'rest_client'
require 'nokogiri'
require 'mechanize'
require 'lib/proxy'
require 'net/http'
require 'uri'

class Scanner

  attr_accessor :browser, :data

  def initialize(site, data)
    @browser = Watir::Browser.new
    @data = data
    @site = site
    @chained = true
    @payload = get_payload
  end

  def http_client=(client)
    @http_client = client
  end

  def data
    @data
  end

  def browser
    @browser
  end


  def http_client
    if @http_client.nil?
      @http_client = Net::HTTP.new($settings['task_server_host'], $settings['task_server_port'])
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

  def scan
    RestClient.proxy = nil
    scan = {}
    begin
      ret, scan = eval(@payload, get_binding)
      unless ret == true
        scan[:error_message] = 'Job failed'
      end
    rescue => e
      scan[:error_message] = "Scan failed for #{@site}: #{e}: #{e.backtrace.join("\n")}"
    end
    browser.close
    scan[:id] = data['id']
    response = {
        :scan => scan,
        :token => $settings['callback_auth_token']
    }
    make_callback(response)
    scan # not used
  end

  def get_payload
    parts = __FILE__.split('/')
    2.times { parts.pop }
    parts.push 'sites', @site, 'SearchListing', 'client_script.rb'
    file_path = parts.join('/')
    File.open(file_path, 'r').read
  end


  # returns binding object for eval() method
  def get_binding
    return binding()
  end
end