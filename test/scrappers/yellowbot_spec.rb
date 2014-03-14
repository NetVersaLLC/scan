require_relative '../spec_helper'
require 'lib/scrappers/yellowbot'
require 'awesome_print'

describe 'Yellowbot' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Yellowbot.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3904 E. Chapman Ave., Orange, CA, 92869"
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.yellowbot.com/inkling-tattoo-gallery-orange-ca.html"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Yellowbot.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end