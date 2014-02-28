require_relative '../spec_helper'
require 'lib/scrappers/foursquare'
require 'awesome_print'

describe 'Foursquare' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Foursquare.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == '3904 E Chapman Ave, Orange, CA, 92869'
    result['listed_phone'].should == ""
    result['listed_url'].should == "http://foursquare.com/v/inkling-tattoo-gallery/4f6a372ae4b068b1a70520d3"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Foursquare.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end