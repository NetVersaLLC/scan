require_relative '../spec_helper'
require 'lib/scrappers/tupalo'
require 'awesome_print'

describe 'Tupalo' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Tupalo.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3904 E. Chapman Ave., Orange, CA, 92869"
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.tupalo.co/orange-california/inkling-tattoo-gallery"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Tupalo.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end