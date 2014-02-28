require_relative '../spec_helper'
require 'lib/scrappers/yelp'

describe 'Yelp' do

  it 'should work for claimed business' do
    scrapper = Yelp.new(sample_data(0))
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == "Inkling Tattoo Gallery"
    result['listed_phone'].should == "(714) 538-8748"
    result['listed_url'].should == "http://www.yelp.com/biz/inkling-tattoo-gallery-orange-2"
    result['listed_address'].should == "3904 E Chapman Ave, Orange, CA, 92869"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(1)
    scrapper = Yelp.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end