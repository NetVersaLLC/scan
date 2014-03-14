require_relative '../spec_helper'
require 'lib/scrappers/ezlocal'
require 'awesome_print'

describe 'Ezlocal' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Ezlocal.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3904 E Chapman Ave, Orange, CA, 92869"
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://ezlocal.com/ca/orange/business/712569917"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(1)
    scrapper = Ezlocal.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end