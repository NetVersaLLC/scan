require_relative '../spec_helper'
require 'lib/scrappers/shopbrazos'
require 'awesome_print'

describe 'Shopbrazos' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Shopbrazos.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3904 E Chapman Ave, Orange, CA, 92869"
    result['listed_phone'].should == "714-538-8748"
    result['listed_url'].should == "http://www.theeagle.com/shopbrazos/business_32816244.html"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Shopbrazos.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end