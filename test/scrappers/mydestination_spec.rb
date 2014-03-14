require_relative '../spec_helper'
require 'lib/scrappers/mydestination'
require 'awesome_print'

describe 'Mydestination' do

  it 'should work for listed business' do
    business_data = sample_data(16)
    scrapper = Mydestination.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == business_data['address']
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.mydestination.com/orlando/restaurants/171723/the-pub-orlando"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Mydestination.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end