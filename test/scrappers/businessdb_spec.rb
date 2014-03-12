require_relative '../spec_helper'
require 'lib/scrappers/businessdb'
require 'awesome_print'

describe 'Businessdb' do

  it 'should work for listed business' do
    business_data = sample_data(12)
    scrapper = Businessdb.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == ""
    result['listed_phone'].should == ""
    result['listed_url'].should == "http://us.copub.com/company/www.pinnaclebuilt.com"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Businessdb.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end
