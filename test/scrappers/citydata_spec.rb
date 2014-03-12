require_relative '../spec_helper'
require 'lib/scrappers/citydata'
require 'awesome_print'

describe 'Citydata' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Citydata.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3904 E Chapman Ave, Orange, CA"
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.city-data.com/bs/?q=Inkling+Tattoo+Gallery&w=92869"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Citydata.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end