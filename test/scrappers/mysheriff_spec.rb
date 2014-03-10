require_relative '../spec_helper'
require 'lib/scrappers/mysheriff'
require 'awesome_print'

describe 'Mysheriff' do

  it 'should work for listed business' do
    business_data = sample_data(9)
    scrapper = Mysheriff.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :claimed
    result['listed_name'].should == business_data['business']
    result['listed_address'].should == "2900 12th Ave. South Nashville  37204"
    result['listed_phone'].should == "615-297-6878"
    result['listed_url'].should == "http://www.mysheriff.net/profile/hair-salon/nashville/930538582/"
  end

  it 'should not fail unlisted business' do
    business_data = sample_data(4)
    scrapper = Mysheriff.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end