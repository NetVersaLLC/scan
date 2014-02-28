require_relative '../spec_helper'
require 'lib/scrappers/cylex'
require 'awesome_print'

describe 'Cylex' do

  it 'should work for listed business' do
    business_data = sample_data(2)
    scrapper = Cylex.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3804 East Chapman Avenue Suite F, Orange, Ca, 92869"
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://orange-orange-ca.cylex-usa.com/company/signal-lounge-11354356.html"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(0)
    scrapper = Cylex.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end