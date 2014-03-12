require_relative '../spec_helper'
require 'lib/scrappers/ebusinesspages'
require 'awesome_print'

describe 'Ebusinesspages' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Ebusinesspages.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :claimed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3904 East Chapman Avenue, Orange, CA, 92869"
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://ebusinesspages.com/Inkling-Tattoo-Gallery_d17di.co"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(1)
    scrapper = Ebusinesspages.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end
