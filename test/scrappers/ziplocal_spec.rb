require_relative '../spec_helper'
require 'lib/scrappers/ziplocal'
require 'awesome_print'

describe 'Ziplocal' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Ziplocal.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3904 E Chapman Ave, Orange, CA, 92869"
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.ziplocal.com/page/CA/orange/inkling-tattoo-gallery/101-12211230.html"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Ziplocal.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end