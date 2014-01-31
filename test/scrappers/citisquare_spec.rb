require_relative '../spec_helper'
require 'lib/scrappers/citisquare'

describe 'Citisquare' do

  it 'should work for listed business' do
    business_data = sample_data(4)
    scrapper = Citisquare.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :claimed
    result['listed_name'].should == business_data['business']
    result['listed_phone'].should == '949-287-3810'
    result['listed_url'].should == "http://citysquares.com/b/crystals-bakery-20172691"
    result['listed_address'].should == "106 31st Street Newport Beach CA 92663"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    business_data['business'] = 'noname business 234'
    business_data['phone'] = '34534534534'

    scrapper = Citisquare.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end


end