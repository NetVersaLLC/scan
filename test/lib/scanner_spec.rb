require_relative '../spec_helper'
require 'json'
require 'lib/scanner'
require 'awesome_print'


describe 'Scanner' do
  it 'should return result for listed business' do #fixme after implementing callbacks and fork
    scanner = Scanner.new('Foursquare', sample_data)
    result = scanner.scan()
    #ap result
    result[:error].should == nil
    result[:result]['listed_name'].should == 'Fifth Third Field'
    result[:result]['listed_url'].should == 'https://foursquare.com/v/4b155072f964a52096b023e3'
    result[:result]['listed_address'].should == '406 Washington St, ToledoOH, 43604-1046'
    result[:result]['listed_phone'].should == '(419) 725-4367'
    result[:result]['status'].should == :claimed
  end

  it 'should not find anything for wrong zip' do
    data = sample_data
    data['zip'] = '00000'
    scanner = Scanner.new('Foursquare', data)
    result = scanner.scan()
    result[:error].should == nil
    result[:result]['status'].should == :unlisted
  end

  it 'should send result to the scanserver thorugh api callback' do

  end

end