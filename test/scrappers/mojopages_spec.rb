require_relative '../spec_helper'
require 'lib/scrappers/mojopages'
require 'awesome_print'

describe 'Mojopages' do

  it 'should work for listed business' do
    business_data = sample_data(0)
    scrapper = Mojopages.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :listed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "3904 E. Chapman Ave., Orange,  CA 92869"
    result['listed_phone'].should == business_data['phone']
    result['listed_url'].should == "http://www.mojopages.com/biz/find?areaCode=714&exchange=538&phoneNumber=8748"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Mojopages.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end