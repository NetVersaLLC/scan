require_relative '../spec_helper'
require 'lib/scrappers/mywebyellow'
require 'awesome_print'

describe 'Mywebyellow' do

  it 'should work for listed business' do
    business_data = sample_data(2)
    scrapper = Mywebyellow.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3804 East Chapman Avenue, Orange, CA 92869"
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://mywebyellow.com/p/Signal-Lounge/Santa_Ana_CA/5945/111032/Signal-Lounge/4/"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Mywebyellow.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end