require_relative '../spec_helper'
require 'json'
require 'lib/scanner'
require 'awesome_print'

describe 'Scanner' do

  it 'should send result to the scanserver thorugh api callback' do
    sample_callback_data = {
        'scan' => {'id' => '123',
                  "listed_name" => "Fifth Third Field",
                  "listed_url" => "http://foursquare.com/v/fifth-third-field/4b155072f964a52096b023e3",
                  "listed_address" => "406 Washington St, ToledoOH, 43604-1046",
                  "listed_phone" => "(419) 725-4367",
                  "status" => 'claimed'},
        'token' => $settings['callback_auth_token']}

    http_client_mock = double('Net::HTTP')
    http_client_mock.should_receive(:post) do |uri,query|
      uri.should eq '/scanapi/submit_scan_result'
      callback_data = Rack::Utils.parse_nested_query(query)
      callback_data.should == sample_callback_data
    end
    scanner = Scanner.new('Foursquare', sample_data(1), 'localhost', 80)
    scanner.http_client = http_client_mock
    scanner.scan
  end


  describe 'get_scrapper' do
    it 'should return new scrapper class instance if corresponding file exists' do
      scanner = Scanner.new('Yelp', {}, 'localhost', 80)
      scanner.scrapper.class.should == Yelp
    end

    it 'should return old scrapper class instance if new scrapper does not exists' do
      scanner = Scanner.new('Testsite', {}, 'localhost', 80)
      scanner.scrapper.class.should == Payload
    end
  end

  describe 'http_client' do
    it 'should use ssl when callback_port is 443 ' do
      scanner = Scanner.new('Yelp', {}, 'localhost', 443)
      scanner.http_client.use_ssl?.should == true
      scanner.http_client.verify_mode.should == OpenSSL::SSL::VERIFY_NONE
    end

    it 'should use ssl when callback_port is "443" ' do
      scanner = Scanner.new('Yelp', {}, 'localhost', '443')
      scanner.http_client.use_ssl?.should == true
      scanner.http_client.verify_mode.should == OpenSSL::SSL::VERIFY_NONE
    end
  end

  #it 'debug' do
  #  sample_callback_data = {
  #      'scan' => {'id' => '123',
  #                 "listed_name" => "Fifth Third Field",
  #                 "listed_url" => "https://foursquare.com/v/fifth-third-field/4b155072f964a52096b023e3",
  #                 "listed_address" => "406 Washington St, ToledoOH, 43604-1046",
  #                 "listed_phone" => "(419) 725-4367",
  #                 "status" => 'claimed'},
  #      'token' => $settings['callback_auth_token']}
  #
  #  scanner = Scanner.new('Foursquare', sample_data)
  #  scanner.scan
  #end

end