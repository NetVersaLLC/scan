require_relative '../spec_helper'
require 'json'
require 'lib/scanner'
require 'awesome_print'


describe 'Scanner' do
  # being replaced with callback
  #it 'should return result for listed business' do #fixme after implementing callbacks and fork
  #  scanner = Scanner.new('Foursquare', sample_data)
  #  result = scanner.scan()
  #  result[:error].should == nil
  #  result[:result]['listed_name'].should == 'Fifth Third Field'
  #  result[:result]['listed_url'].should == 'https://foursquare.com/v/4b155072f964a52096b023e3'
  #  result[:result]['listed_address'].should == '406 Washington St, ToledoOH, 43604-1046'
  #  result[:result]['listed_phone'].should == '(419) 725-4367'
  #  result[:result]['status'].should == :claimed
  #end

  #it 'should not find anything for wrong zip' do
  #  data = sample_data
  #  data['zip'] = '00000'
  #  scanner = Scanner.new('Foursquare', data)
  #  result = scanner.scan()
  #  result[:error].should == nil
  #  result[:result]['status'].should == :unlisted
  #end

  it 'should send result to the scanserver thorugh api callback' do
    sample_callback_data = {
        'scan' => {'id' => '123',
                  "listed_name" => "Fifth Third Field",
                  "listed_url" => "https://foursquare.com/v/fifth-third-field/4b155072f964a52096b023e3",
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
    scanner = Scanner.new('Foursquare', sample_data)
    scanner.http_client = http_client_mock
    scanner.scan
  end

end