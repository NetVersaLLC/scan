require_relative '../spec_helper'
require 'lib/scrappers/twitter'

describe 'Twitter' do

  it 'should work' do
    scrapper = Twitter.new(sample_data(5))
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :claimed
    result['listed_name'].should == "McDonald's"
    result['listed_address'].should == ""
    result['listed_phone'].should == ""
    result['listed_url'].should == "http://twitter.com/McDonalds"
  end

  it 'should not fail for unlisted business' do
    business_data = sample_data(0)
    business_data['business'] = 'noname business 234'
    business_data['phone'] = '34534534534'

    scrapper = Twitter.new(business_data)
    result = scrapper.execute
    result.class.should == Hash
    result['status'].should == :unlisted
  end

end